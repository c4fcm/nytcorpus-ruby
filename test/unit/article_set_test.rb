require 'config/environment'
require 'test/test_helper'

require 'app/models/article_set'

class TestArticleSet< Test::Unit::TestCase

  def setup
    @base_dir = "test/fixtures"
  end

  def teardown
  end
 
  def test_filename
    csv_name = ArticleSet.csv_filename(1987,6)
    assert_equal csv_name, "data_1987_06.csv"
  end
 
  def test_load_csv
    csv_name = ArticleSet.csv_filename(1987,6)
    csv_path = File.join(@base_dir,csv_name)
    dataset = ArticleSet.from_csv_file(csv_path)
    assert_not_nil dataset
  end
  
  def test_length
    csv_name = ArticleSet.csv_filename(1987,6)
    csv_path = File.join(@base_dir,csv_name)
    dataset = ArticleSet.from_csv_file(csv_path)
    assert_equal dataset.article_count, 1362
  end
  
  def test_get_matching
    csv_name = ArticleSet.csv_filename(1987,6)
    csv_path = File.join(@base_dir,csv_name)
    dataset = ArticleSet.from_csv_file(csv_path)
    new_dataset = dataset.get_matching(:@taxonomic_classifiers,".*World.*")
    assert_equal 169, new_dataset.article_count
    assert_equal 1362, dataset.article_count
    new_dataset = dataset.get_matching(:@taxonomic_classifiers,"DUMMY.*")
    assert_equal 0, new_dataset.article_count
  end

  def test_filter_unique_articles
    csv_name = ArticleSet.csv_filename(1920, 01)
    csv_path = File.join(File.join(@base_dir), csv_name)
    dataset = ArticleSet.from_csv_file(csv_path)
    assert_equal 4, dataset.articles.size
    uniques = dataset.filter_unique_articles
    assert_equal 2, uniques.size
    dataset.filter_unique_articles!
    assert_equal 2, dataset.articles.size
  end
end
