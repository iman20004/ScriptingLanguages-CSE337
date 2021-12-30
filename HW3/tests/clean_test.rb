require 'test/unit'
require 'test/unit/assertions'
require_relative "../clean_string.rb"

class MyTest < Test::Unit::TestCase
  def test_clean_str_1
    assert_equal('Ada Lovelace', clean('Ada Lovelace'))
  end

  def test_clean_str_2
    assert_equal('Arya bhatta',clean('   Arya bhatta'))
  end

  def test_clean_str_3
    assert_equal('Arya bhatta', clean('   Arya bhatta '))
  end

  def test_clean_str_4
    assert_equal('goodbye', clean("\tgoodbye\r\n"))
  end

  def test_clean_str_5
    assert_equal('', clean("\t\n\v\f\r "))
  end

  def test_case_str_6
    assert_equal('Mary Jackson', clean('ouiMary Jacksonooooo', "iou"))
  end

  def test_case_str_7
    assert_equal('ary Jacks', clean('ouiMary Jacksonooooo', "iouMJn"))
  end

  def test_case_str_8
    assert_equal('Damascus', clean('<<Damascus>>>', "<>"))
  end

  def test_case_str_9
    assert_equal(' <Ruby> ', clean('< <Ruby> >>', "<>"))
  end

  def test_case_str_10
    assert_equal('', clean('python', 'nthopy'))
  end
end
