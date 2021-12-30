require 'test/unit'
require 'test/unit/assertions'
require_relative "../insert_file.rb"

class InsertFileTest < Test::Unit::TestCase
  def setup
    FileUtils.rm_rf(Dir.new('tmp-data')) if Dir.exist?('tmp-data')
    Dir.mkdir('tmp-data')
  end

  def teardown
    FileUtils.rm_rf(Dir.new('tmp-data')) if Dir.exist?('tmp-data')
  end

  def test_insert_empty_dir
    insert(Dir.new('tmp-data'), 'snap010.txt')
    assert(File.exist?(File.join('tmp-data','snap010.txt')), 'Expected snap010.txt to exist')
  end

  def test_insert_empty_dir_1
    File.new(File.join('tmp-data', 'snp101.txt'), 'a+').close
    insert(Dir.new('tmp-data'), 'snap010.txt')
    assert(File.exist?(File.join('tmp-data','snap010.txt')), 'Expected snap010.txt to exist')
    assert(File.exist?(File.join('tmp-data','snp101.txt')), 'Expected snp101.txt to exist')
  end

  def test_insert_inv_filenm
    assert_equal('invalid filename', insert(Dir.new('tmp-data'), ''))
    assert(Dir.empty?('tmp-data'), 'Expected tmp-data to be empty')
  end

  def test_insert_inv_fileNm_1
    File.new(File.join('tmp-data','snap001.txt'), 'a+').close
    File.new(File.join('tmp-data','snap002.txt'), 'a+').close
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('invalid filename', insert(Dir.new('tmp-data'), 'snap03.txt'))
    assert(File.exist?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    refute(File.exist?(File.join('tmp-data','snap03.txt')), 'Expected snap005.txt to exist')
  end

  def test_insert_inv_fileNm_2
    File.new(File.join('tmp-data','snap9995.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9996.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9997.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9998.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9999.txt'), 'a+').close
    assert_equal('invalid filename', insert(Dir.new('tmp-data'), 'snap9994.txt'))
    refute(File.exist?(File.join('tmp-data','snap9994.txt')), 'Expected snap9994.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9995.txt')), 'Expected snap9995.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9996.txt')), 'Expected snap9996.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9997.txt')), 'Expected snap9997.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9998.txt')), 'Expected snap9998.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9999.txt')), 'Expected snap9999.txt to exist')
  end

  def test_insert_inv_fileNm_3
    File.new(File.join('tmp-data','snap9995.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9996.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9997.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9998.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9999.txt'), 'a+').close
    assert_equal('invalid filename', insert(Dir.new('tmp-data'), 'snap10000.txt'))
    refute(File.exist?(File.join('tmp-data','snap10000.txt')), 'Expected snap10000.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9995.txt')), 'Expected snap9995.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9996.txt')), 'Expected snap9996.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9997.txt')), 'Expected snap9997.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9998.txt')), 'Expected snap9998.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9999.txt')), 'Expected snap9999.txt to exist')
  end

  def test_insert_inv_fileNm_4
    File.new(File.join('tmp-data','config.txt'), 'a+').close
    File.new(File.join('tmp-data','snap001.txt'), 'a+').close
    File.new(File.join('tmp-data','snap002.txt'), 'a+').close
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('invalid filename', insert(Dir.new('tmp-data'), 'config001.txt'))
    assert(File.exist?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    refute(File.exist?(File.join('tmp-data','snap03.txt')), 'Expected snap005.txt to exist')
  end

  def test_insert_dir_1
    File.new(File.join('tmp-data','a.txt'), 'a+').close
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap004.txt'))
    assert(File.exist?(File.join('tmp-data','a.txt')), 'Expected a.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap006.txt')), 'Expected snap006.txt to exist')
    refute(File.exist?(File.join('tmp-data','snap007.txt')), 'Expected snap007.txt to exist')
  end

  def test_insert_dir_2
    File.new(File.join('tmp-data','snap001.txt'), 'a+').close
    File.new(File.join('tmp-data','snap002.txt'), 'a+').close
    File.open(File.join('tmp-data','snap003.txt'), 'a+') { |file|
      file.write('snap003')
      file.close
    }
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap003.txt'))
    assert(File.exist?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.zero?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to be empty')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    f = File.open(File.join('tmp-data','snap004.txt'), 'r')
    assert_equal('snap003', f.read)
    f.close
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap006.txt')), 'Expected snap006.txt to exist')
  end

  def test_insert_dir_3
    File.new(File.join('tmp-data','config.txt'), 'a+').close
    File.new(File.join('tmp-data','bsnap876.txt'), 'a+').close
    File.new(File.join('tmp-data','snap002.txt'), 'a+').close
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap003.txt'))
    assert(File.exist?(File.join('tmp-data','config.txt')), 'Expected config.txt to exist')
    assert(File.exist?(File.join('tmp-data','bsnap876.txt')), 'Expected bsnap001.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap006.txt')), 'Expected snap006.txt to exist')
  end

  def test_insert_dir_4
    File.open(File.join('tmp-data','snap001.txt'), 'a+') { |file|
      file.write('snap001')
      file.close
    }
    File.new(File.join('tmp-data','snap002.txt'), 'a+').close
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap001.txt'))
    assert(File.exist?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to exist')
    assert(File.zero?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to be empty')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    f = File.open(File.join('tmp-data','snap002.txt'), 'r')
    assert_equal('snap001', f.read)
    f.close
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap006.txt')), 'Expected snap006.txt to exist')
  end

  def test_insert_dir_5
    File.new(File.join('tmp-data','snap001.txt'), 'a+').close
    File.open(File.join('tmp-data','snap002.txt'), 'a+') { |file|
      file.write('snap002')
      file.close
    }
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap002.txt'))
    assert(File.exist?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    assert(File.zero?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to be empty')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    f = File.open(File.join('tmp-data','snap003.txt'), 'r')
    assert_equal('snap002', f.read)
    f.close
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap006.txt')), 'Expected snap006.txt to exist')
  end

  def test_insert_dir_6
    File.new(File.join('tmp-data','snap001.txt'), 'a+').close
    File.new(File.join('tmp-data','snap002.txt'), 'a+').close
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    File.new(File.join('tmp-data','snap005.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap005.txt'))
    assert(File.exist?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap006.txt')), 'Expected snap006.txt to exist')
  end

  def test_insert_dir_7
    File.new(File.join('tmp-data','snap001.txt'), 'a+').close
    File.new(File.join('tmp-data','snap002.txt'), 'a+').close
    File.new(File.join('tmp-data','snap003.txt'), 'a+').close
    File.new(File.join('tmp-data','snap004.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap004.txt'))
    assert(File.exist?(File.join('tmp-data','snap001.txt')), 'Expected snap001.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap002.txt')), 'Expected snap002.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap003.txt')), 'Expected snap003.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap004.txt')), 'Expected snap004.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap005.txt')), 'Expected snap005.txt to exist')
  end

  def test_insert_dir_8
    File.new(File.join('tmp-data','snap1212.txt'), 'a+').close
    File.new(File.join('tmp-data','snap1213.txt'), 'a+').close
    File.new(File.join('tmp-data','snap1214.txt'), 'a+').close
    File.new(File.join('tmp-data','snap1215.txt'), 'a+').close
    File.new(File.join('tmp-data','snap1216.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap1215.txt'))
    assert(File.exist?(File.join('tmp-data','snap1212.txt')), 'Expected snap1212.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap1213.txt')), 'Expected snap1213.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap1214.txt')), 'Expected snap1214.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap1215.txt')), 'Expected snap1215.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap1216.txt')), 'Expected snap1216.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap1217.txt')), 'Expected snap1217.txt to exist')
  end

  def test_insert_dir_9
    File.new(File.join('tmp-data','snap9995.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9996.txt'), 'a+').close
    File.open(File.join('tmp-data','snap9997.txt'), 'a+') { |file|
      file.write('snap9997')
      file.close
    }
    File.new(File.join('tmp-data','snap9998.txt'), 'a+').close
    File.new(File.join('tmp-data','snap9999.txt'), 'a+').close
    assert_equal('done', insert(Dir.new('tmp-data'), 'snap9997.txt'))
    assert(File.exist?(File.join('tmp-data','snap9995.txt')), 'Expected snap9995.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9996.txt')), 'Expected snap9996.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap9997.txt')), 'Expected snap9997.txt to exist')
    assert(File.zero?(File.join('tmp-data','snap9997.txt')), 'Expected snap9997.txt to be empty')
    assert(File.exist?(File.join('tmp-data','snap9998.txt')), 'Expected snap9998.txt to exist')
    f = File.open(File.join('tmp-data','snap9998.txt'), 'r')
    assert_equal('snap9997', f.read)
    f.close
    assert(File.exist?(File.join('tmp-data','snap9999.txt')), 'Expected snap9999.txt to exist')
    assert(File.exist?(File.join('tmp-data','snap10000.txt')), 'Expected snap10000.txt to exist')
  end

end
