class KohlsTransactions

  require 'open-uri'

  LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]
  LinkshareAPI.token = ENV["LINKSHARE_TOKEN"]

  def self.kohls_update_coupons
    textlinks = LsLinkdirectAPI::TextLinks.new
    params = { mid: 38605, cat: -1, endDate: Time.now.strftime("%m%d%Y") }
    response = textlinks.get(params)
  
    response.data.each do |item|
      coupon_hash = {
        link: item.clickURL,
        id_of_coupon: item.linkID.to_i,
        description: "#{item.textDisplay}",
        title: make_title("#{item.linkName}", "#{item.textDisplay}"),
        start_date: Time.parse(item.startDate),
        code: find_coupon_code("#{item.textDisplay}"),
        restriction: nil,
        impression_pixel: item.showURL
      }
  
      unless RemovedCoupon.pluck(:id_of_coupon).include? coupon_hash[:id_of_coupon]
        if item.endDate == nil || item.endDate == '' || item.endDate.downcase == "ongoing"
          coupon_hash[ :end_date ] = DateTime.now + 5.years
        else
          coupon_hash[ :end_date ] = Time.parse(item.endDate)
        end

        new_coupon = Coupon.new(coupon_hash)
        name_check = FindKeywords::Keywords.new("#{item.linkName} #{item.textDisplay} #{item.categoryName}").keywords.join(" ")
        name_check_raw = "#{item.linkName} #{item.textDisplay} #{item.categoryName}"
        
        

        if new_coupon.save

          find_kohls_cat(name_check).each do | kohls_cat |
            new_coupon.kohls_categories << KohlsCategory.find_by_kc_id(kohls_cat) if kohls_cat
          end

          find_kohls_only(name_check).each do | only_kohls |
            new_coupon.kohls_onlies << KohlsOnly.find_by_kc_id(only_kohls) if only_kohls
          end

          find_kohls_type(name_check_raw).each do | type_kohls |
            new_coupon.kohls_types << KohlsType.find_by_kc_id(type_kohls) if type_kohls
          end
        
          new_coupon.kohls_types << KohlsType.find_by_kc_id(4) if new_coupon.code
          
          #require 'pry'; binding.pry
          new_coupon.remote_image_url = find_product_image(name_check)
          new_coupon.save
        end
      end
    end
    Coupon.all.each { |c| c.touch }
  end
 
  def self.find_kohls_cat(term)
    #1 For The Home, 2 Bed & Bath, 3 Furniture, 4 Women, 5 Swin, 6 Men, 7 Teens, 8 Kids,
    #9 Baby, 10 shoes, 11 Jewlery & Watches, Sports Fan Shop
    kohls_cat_hash = {
      1 => ['patio','grills','outdoor','bbq','hammocks','gazebos','tailgating','garden','bird','stepping','appliances','coffee','tea','cookware','bakeware','cooking','cutlery','cookbooks','food','cleaning','kitchen','rugs','dinnerware','flatware','silverware','table','wine','dining','office','bar','home','speakers','bareware','glassware','serveware','scraper', 'humidifier'],
      2 => ['bedskirts','blankets','throws','comforters','comforter','duvet','mattress','mattresses','pillows','shams','quilts','sheets','bedding','towels','towel','shower','bath','personal'],
      3 => ['furniture','art','candles','decorative','lighting','lamp','lamps','frames','albums','cushions','slipcovers','rugs','treatments'],
      4 => ['women','women\'s','capris','dresses','intimates','bras','panties','shapewear','handbags'],
      5 => ['swimsuit','tankini','bikini','cover-ups'],
      6 => ['men','men\'s','polos','ties','urban'],
      7 => ['teen','teen\'s','prom','juniors','girls','boys'],
      8 => ['kids','toddler','toys'],
      9 => ['baby','stroller','carriers','diaper','babies','infant','infants','newborns'],
      10 => ['shoes','boot','boots','clogs','flats','flip-flops','pumps','heels','oxfords','sandals','slippers','wedges','loafers','cleats'],
      11 => ['jewelry','watches','watch','rings','necklaces','earrings','bracelets','beads','charms','gemstones','diamonds','pins','diamond','pearl'],
      12 => ['ncaa','mlb','nfl','nba','nhl','olympics','nascar','soccer','basketball','fan']
    }

    cloths = ['capris','coats','coat','dresses','dress','jackets','jacket','blazers','blazer','jeans','pants','leggings','shirts','tees','shirt','tee','shorts','skirt','skirts','pajamas','robes','robe','suit','suits','sweater','sweaters','workout','socks','underwear','belt','tops','top','yoga','active','clothes','activewear','sonoma','jeggings']
    categories = []
    kohls_cat_hash.each do | cat_id, match_words |
      categories << cat_id if have_term?(match_words, term)
    end

    if categories.count == 0
      categories << 4 if have_term?(cloths, term)
    end

    categories
  end

  def self.find_kohls_only(term)
    #1 Lauren Conrad, 2 Jennifer Lopez, 3 Marc Anthony, 4 Gold Clearence, 5 Rock & Republic
    #6 Candie's, 7 Dana Buchman, 8 Elle
    kohls_only_hash = {
      1 => ['lauren','conrad'],
      2 => ['jennifer','lopez'],
      3 => ['marc','anthony'],
      4 => ['gold','clearance'],
      5 => ['rock','republic'],
      6 => ['candies'],
      7 => ['dana','buchman'],
      8 => ['elle']
    }

    onlys = []
    kohls_only_hash.each do | cat_id, match_words |
      onlys << cat_id if have_term?(match_words, term)
    end
    onlys
  end

  def self.find_kohls_type(term)
    #1=> 'Dollar Off', 2=> 'Percent Off', 3=> 'Free Shipping', 4=>'Coupon Code', 5=>'General Promotion', 15=> 'Printable Coupon'
    term.downcase!
    kohls_type_hash = {
      1 => [/\$/],
      2 => [/\%/],
      3 => [/free shipping/, /ships free/, /free standard shipping/],
      4 => [/code/],
      6 => [/sitewide/],
      15 => [/print/, /printable/]
    }

    types = []
    
    kohls_type_hash.each do | cat_id, match_words |
      match_words.each do | match_word |
        types << cat_id if term =~ match_word
      end
    end
    #types << 2 if term.include? '% '
    types << 5 if types.count == 0
    
    types.uniq   
  end

  def self.find_coupon_code(term)
    term ||= ''
    if term =~ /no promo code needed/i
      nil
    else
      if term.include? " "
        code_array = ["code","code:", "Code", "Code:"]
        term_array = term.split(" ").collect(&:strip)
        code_have = []
        #require 'pry'; binding.pry
        code_array.each do | code |
          code_have << code if term_array.include?("#{code}")
        end
        
        if code_have.size != 0
          term_array[term_array.index(code_have[0]).to_i + 1].gsub!(/[^a-zA-Z0-9]/,'')
        else
          nil
        end
      else
        nil
      end
    end
  end

  def self.find_product_image(keywords)
    keywords = 'kohls' if keywords == ""
    options = {
      one: keywords,
      mid: 38605, # kohls
      #cat: "Electronics",
      max: 1,
      #sort: :retailprice,
      #sorttype: :asc
    }
    #require 'pry'; binding.pry
    response = LinkshareAPI.product_search(options)

    if response.total_matches == 0
      nil
    else
      response.data.first.imageurl
    end
  end

  def self.title_short(title)
    title ||= ' '
    title.delete!('()') if title.include?('(')
    right_split = [/valid.*/i, /reg.*/i, /with code.*/i, /purchase.*/i, /with promo code.*/i, /orig.*/i]

    title_out = String.new
    t = Array.new
    right_split.each_with_index do |split_word, i|
      s = title.slice(split_word)
      t[i] = title
      #require 'pry'; binding.pry

      t[i].remove!(s) if s && t[i].length != s.length
      
      
      title_out = t[i] if t[i].length <= title_out.length || i == 0 
    end

    title_out.strip!
    title_out.chomp!('.') if title_out.end_with?('.')
    title_out.gsub!('-', ' to ') if title_out =~ (/\d[-]\d/)
    output = title_out.titleize
    output.gsub!('To', 'to') if output.include?(' To ')
    output
  end

  def self.title_shorten(title, length = 50)
    title.delete!('()') if title.include?('(')
    name = title.strip.downcase.gsub(/(\d{2}|\d{1})\/(\d{2}|\d{1})(-|.-.)(\d{2}|\d{1})\/(\d{2}|\d{1})/, "")  #.gsub(/(sept|oct|nov|dec|jan|feb|mar|apr|may|jun|jul|aug)(\s*)(\d*|)(-|.-.|)/,"")
    name.gsub!(/[^a-z\s\&]/i,"")
    name_array = name.split(" ")
    items_to_remove = ['reg', 'all', 'orig', 'valid', 'code']

    items_to_remove.each do |remove|
      name_array.reject! { |item| item.include?(remove) }
    end
    name = name_array.uniq.join(" ")

    break_words = [' with ',' on a ','off ',' at ', ': ',' on ',' just ',' up to ',' - ',' for ',' w/ ', ' of ']
    break_words.each do | break_word |
      if break_word == ' at '
        @b_length = 100
        @pos = 1
      else
        @b_length = name.length
        @pos = (@b_length / 2).to_i
      end

      break if @b_length < length
      
      if name.index(break_word)
        find_on = name.split(break_word)
        if name.index(break_word) < @pos
          name = find_on[1]
        else
          name = find_on[0]
        end
      end
    end

    while name.length > length
      name_array = name.split(" ")
      name_array.pop
      name = name_array.join(" ")
    end
    
    #name.gsub!(/[[:punct:]]/,"")
    name_array = name.split(" ")
    items_to_remove = ['off', 'with']

    items_to_remove.each do |remove|
      name_array.reject! { |item| item.include?(remove) }
    end
    name = name_array.join(" ")
    #name.gsub!(/[\]\[!"#$%'()*+,.\/:;<=>?@\^_`{|}~-]/,"")
    name.gsub!(/#{Regexp.escape('\/')}/, "")
    title.titleize
  end

  def self.make_title(title, description)
    if title == description
      title_short(title)
    else
      if title.length < 50
        title_short(title)
      else
        title_short(title)
      end
    end
  end

  def self.addspin(name)
    spintax = "{kohls cash code|kohls promotional codes|kohls 30 percent off|kohls online coupons|kohls 30 coupon|kohls discount|kohls discount codes|kohls coupon 30|kohl coupons|kohls coupons 30|kohls online coupon|kohls promo|kohls free shipping|kohls 30|kohls discount code|kohls sales|kohls sale|kohls codes|coupons for kohls|kohls coupon codes|kohls promo codes|kohl|kohl s|kohls coupon code|kohls coupon|kohls promo code|kohls coupons}"
    "#{spintax.unspin} #{name}"
  end

  private

  def self.have_term?(words, term)
    if words.select{ |word| term.downcase.insert(0," ").include? word.insert(0," ") }.join("") == ""
      return false
    end
    true
  end
end