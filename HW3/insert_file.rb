########### IMAN ALI ###########
########### imaali ###########
########### 112204305 ###########

require 'fileutils'
def insert(dir, filename)
  # Check if dir has any file with snap format
  exists = false
  Dir.each_child(dir) {|file|
    exists = file.match? /(^snap)(\d{3,4})(\.txt$)/
  }

  # if empty file and valid filename, insert
  if Dir.empty?(dir) or not exists
    if filename.match? /(^snap)(\d\d\d)(\.txt)/
      File.new(File.join(dir, filename), "w")
      return "done"
    else
      return "invalid filename"
    end
  end

  # If filename not already present, then invalid
  if not File.exist?(File.join(dir,filename))
    return "invalid filename"
  end

  # Get min and max snap format num
  snapFiles = []
  Dir.each_child(dir) {|file|
    if file.match? /(^snap)(\d{3,4})(\.txt$)/
      snapFiles.append(file)
    end
  }

  # Sort files by descending file name order and also intialize start and end value
  files = Dir.children(dir).select {|f| f =~ /(^snap)(\d{3,4})(\.txt$)/}
  if files[0] =~ /(^snap)(\d{3})(\.txt$)/
    first =  (files[0][4..6]).to_i
  elsif files[0] =~ /(^snap)(\d{4})(\.txt$)/
    first =  (files[0][4..7]).to_i
  end

  files = files.sort.reverse

  if files[0] =~ /(^snap)(\d{3})(\.txt$)/
    last =  (files[0][4..6]).to_i
  elsif files[0] =~ /(^snap)(\d{4})(\.txt$)/
    last =  (files[0][4..7]).to_i
  end

  # Invalid if filename min or max
  if filename == first or filename == last
    return "invalid filename"
  end

  files.each {|file|
    if file.match? /(^snap)(\d\d\d)(\.txt$)/ and (file[4..6]).to_i >= (filename[4..6]).to_i
      num = (file[4..6]).to_i + 1
      temp = "snap00"+num.to_s+".txt"
      newname = File.join(dir, temp)
      oldname = File.join(dir, file)
      File.rename(oldname, newname)
    elsif file.match? /(^snap)(\d\d\d\d)(\.txt$)/ and (file[4..7]).to_i >= (filename[4..7]).to_i
      num = (file[4..7]).to_i + 1
      temp = "snap"+num.to_s+".txt"
      newname = File.join(dir, temp)
      oldname = File.join(dir, file)
      FileUtils.mv(oldname, newname)
    end
  }

  File.new(File.join(dir, filename), "a+")
  return "done"

end
