require 'minitest/autorun'
require 'tax_code'

class TaxCodeTest < MiniTest::Unit::TestCase
  def test_prebaked_files
    res = TaxCode.new('test/repo').taxes
    assert res['test/repo/renamed'] > 0
    assert res['test/repo/multiple_commits'] > res['test/repo/renamed']
    assert res['test/repo/refactored'] == 0
    assert res['test/repo/committed_once'] == 0
    assert res['test/repo/commited_once'] == nil # File removed from repo
  end
end
