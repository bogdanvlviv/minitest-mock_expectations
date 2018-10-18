require "test_helper"

class Minitest::MockExpectations::AssertionsTest < Minitest::Test
  class Post
    attr_accessor :title, :body
    attr_reader :comments

    def initialize(title: "", body: "", comments: [])
      @title = title
      @body = body
      @comments = comments
    end

    def add_comment(comment)
      @comments << comment

      "Thank you!"
    end
  end

  def setup
    @post = Post.new(
      title: "What is new in Rails 6.0",
      body: "https://bogdanvlviv.com/posts/ruby/rails/what-is-new-in-rails-6_0.html",
      comments: [
        "Looking really good.",
        "I'm really like this post."
      ]
    )
  end

  def test_assert_called_with_defaults_to_expect_once
    assert_called @post, :title do
      @post.title
    end
  end

  def test_assert_called_more_than_once
    assert_called(@post, :title, times: 2) do
      @post.title
      @post.title
    end
  end

  def test_assert_called_method_with_arguments
    assert_called(@post, :add_comment) do
      @post.add_comment("Thanks for sharing this.")
    end
  end

  def test_assert_called_returns
    assert_called(@post, :title, returns: "What is new in Rails 5.2") do
      assert_equal "What is new in Rails 5.2", @post.title
    end

    assert_equal "What is new in Rails 6.0", @post.title
  end

  def test_assert_called_failure
    error = assert_raises(Minitest::Assertion) do
      assert_called(@post, :title) do
      end
    end

    assert_equal "Expected title to be called 1 times, but was called 0 times.\nExpected: 1\n  Actual: 0", error.message
  end

  def test_assert_not_called
    assert_not_called(@post, :title) do
      @post.body
    end
  end

  def test_assert_not_called_failure
    error = assert_raises(Minitest::Assertion) do
      assert_not_called(@post, :title) do
        @post.title
      end
    end

    assert_equal "Expected title to be called 0 times, but was called 1 times.\nExpected: 0\n  Actual: 1", error.message
  end

  def test_assert_called_with_message
    error = assert_raises(Minitest::Assertion) do
      assert_called(@post, :title, "Message") do
      end
    end

    assert_equal "Message.\nExpected title to be called 1 times, but was called 0 times.\nExpected: 1\n  Actual: 0", error.message
  end

  def test_assert_called_with_arguments
    assert_called_with(@post, :add_comment, ["Thanks for sharing this."]) do
      @post.add_comment("Thanks for sharing this.")
    end
  end

  def test_assert_called_with_arguments_and_returns
    assert_called_with(@post, :add_comment, ["Thanks for sharing this."], returns: "Thanks!") do
      assert_equal "Thanks!", @post.add_comment("Thanks for sharing this.")
    end

    assert_equal "Thank you!", @post.add_comment("Thanks for sharing this.")
  end

  def test_assert_called_with_failure
    assert_raises(MockExpectationError) do
      assert_called_with(@post, :add_comment, ["Thanks for sharing this."]) do
        @post.add_comment("Thanks")
      end
    end
  end

  def test_assert_called_with_multiple_expected_arguments
    assert_called_with(@post, :add_comment, [["Thanks for sharing this."], ["Thanks!"]]) do
      @post.add_comment("Thanks for sharing this.")
      @post.add_comment("Thanks!")
    end
  end

  def test_assert_called_on_instance_of_with_defaults_to_expect_once
    assert_called_on_instance_of Post, :title do
      @post.title
    end
  end

  def test_assert_called_on_instance_of_more_than_once
    assert_called_on_instance_of(Post, :title, times: 2) do
      @post.title
      @post.title
    end
  end

  def test_assert_called_on_instance_of_with_arguments
    assert_called_on_instance_of(Post, :add_comment) do
      @post.add_comment("Thanks for sharing this.")
    end
  end

  def test_assert_called_on_instance_of_returns
    assert_called_on_instance_of(Post, :title, returns: "What is new in Rails 5.2") do
      assert_equal "What is new in Rails 5.2", @post.title
    end

    assert_equal "What is new in Rails 6.0", @post.title
  end

  def test_assert_called_on_instance_of_failure
    error = assert_raises(Minitest::Assertion) do
      assert_called_on_instance_of(Post, :title) do
      end
    end

    assert_equal "Expected title to be called 1 times, but was called 0 times.\nExpected: 1\n  Actual: 0", error.message
  end

  def test_assert_called_on_instance_of_with_message
    error = assert_raises(Minitest::Assertion) do
      assert_called_on_instance_of(Post, :title, "Message") do
      end
    end

    assert_equal "Message.\nExpected title to be called 1 times, but was called 0 times.\nExpected: 1\n  Actual: 0", error.message
  end

  def test_assert_called_on_instance_of_nesting
    assert_called_on_instance_of(Post, :title, times: 3) do
      assert_called_on_instance_of(Post, :body, times: 2) do
        @post.title
        @post.body
        @post.title
        @post.body
        @post.title
      end
    end
  end

  def test_assert_not_called_on_instance_of
    assert_not_called_on_instance_of(Post, :title) do
      @post.body
    end
  end

  def test_assert_not_called_on_instance_of_failure
    error = assert_raises(Minitest::Assertion) do
      assert_not_called_on_instance_of(Post, :title) do
        @post.title
      end
    end

    assert_equal "Expected title to be called 0 times, but was called 1 times.\nExpected: 0\n  Actual: 1", error.message
  end

  def test_assert_not_called_on_instance_of_nesting
    assert_not_called_on_instance_of(Post, :title) do
      assert_not_called_on_instance_of(Post, :body) do
      end
    end
  end
end
