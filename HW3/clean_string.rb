########### IMAN ALI ###########
########### imaali ###########
########### 112204305 ###########
def clean(s, args = nil)
  if args
    chars = args.split('')
    loop = true
    # check if any char is at end or start
    while loop

      # remove all trailing and leading occurences of char c
      chars.each { |c|
        s.gsub!( /^#{c}*/, "" )
        s.gsub!( /#{c}*$/, "" )
      }

      # check if any character is at start or end of modified string
      chars.each {|c|
         if (s =~ /^#{c}/) == 0 or (s =~ /#{c}$/) == 0
           loop = true
           break
         else
           loop = false
         end
      }
    end
    return s
  end
  s.strip
end
