
[1mFrom:[0m /home/kirk/rails_projects/akc/app/services/kohls_transactions.rb @ line 186 KohlsTransactions.title_short:

    [1;34m177[0m: [32mdef[0m [1;36mself[0m.[1;34mtitle_short[0m(title)
    [1;34m178[0m: 
    [1;34m179[0m:   right_split = [[35m[1;35m/[0m[35mvalid.*[1;35m/[0m[35m[35mi[0m[35m[0m, [35m[1;35m/[0m[35mreg.*[1;35m/[0m[35m[35mi[0m[35m[0m, [35m[1;35m/[0m[35mwith code.*[1;35m/[0m[35m[35mi[0m[35m[0m, [35m[1;35m/[0m[35mpurchase.*[1;35m/[0m[35m[35mi[0m[35m[0m, [35m[1;35m/[0m[35mwith promo code.*[1;35m/[0m[35m[35mi[0m[35m[0m]
    [1;34m180[0m: 
    [1;34m181[0m:   title_out = [1;34;4mString[0m.new
    [1;34m182[0m:   t = [1;34;4mArray[0m.new
    [1;34m183[0m:   right_split.each_with_index [32mdo[0m |split_word, i|
    [1;34m184[0m:     s = title.slice(split_word)
    [1;34m185[0m:     t[i] = title
 => [1;34m186[0m:     require [31m[1;31m'[0m[31mpry[1;31m'[0m[31m[0m; binding.pry
    [1;34m187[0m: 
    [1;34m188[0m:     [32mif[0m t[i].length == s.length
    [1;34m189[0m:     
    [1;34m190[0m:     [32melse[0m
    [1;34m191[0m:       t[i].remove!(s) [32mif[0m s
    [1;34m192[0m:     [32mend[0m
    [1;34m193[0m:     
    [1;34m194[0m:     title_out = t[i] [32mif[0m t[i].length <= title_out.length || i == [1;34m0[0m 
    [1;34m195[0m:   [32mend[0m
    [1;34m196[0m: 
    [1;34m197[0m:   title_out.strip!
    [1;34m198[0m:   title_out
    [1;34m199[0m: 
    [1;34m200[0m: [32mend[0m

