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
      body: "https://gitlab.com/bogdanvlviv/posts/-/issues/15",
      comments: [
        "Wow.",
        "I like this post."
      ]
    )
  end

  def test_assert_called_with_defaults_to_expect_once
    assert_called(@post, :title) do
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

  def test_assert_called_failure_because_method_has_not_been_called
    error = assert_raises(Minitest::Assertion) do
      assert_called(@post, :title) do
        @post.body
      end
    end

    assert_equal "Expected title to be called 1 times, but was called 0 times.\nExpected: 1\n  Actual: 0", error.message
  end

  def test_assert_called_failure_because_method_has_been_called_more_than_expected_times
    error = assert_raises(Minitest::Assertion) do
      assert_called(@post, :title) do
        @post.title
        @post.title
      end
    end

    assert_equal "Expected title to be called 1 times, but was called 2 times.\nExpected: 1\n  Actual: 2", error.message
  end

  def test_assert_called_failure_with_message
    error = assert_raises(Minitest::Assertion) do
      assert_called(@post, :title, "Message") do
        @post.body
      end
    end

    assert_equal "Message.\nExpected title to be called 1 times, but was called 0 times.\nExpected: 1\n  Actual: 0", error.message
  end

  def test_refute_called
    refute_called(@post, :title) do
      @post.body
    end
  end

  def test_refute_called_failure_because_method_has_been_called
    error = assert_raises(Minitest::Assertion) do
      refute_called(@post, :add_comment) do
        @post.add_comment("Thanks for sharing this.")
      end
    end

    assert_equal "Expected add_comment to be called 0 times, but was called 1 times.\nExpected: 0\n  Actual: 1", error.message
  end

  def test_refute_called_failure_with_message
    error = assert_raises(Minitest::Assertion) do
      refute_called(@post, :title, "Message") do
        @post.title
      end
    end

    assert_equal "Message.\nExpected title to be called 0 times, but was called 1 times.\nExpected: 0\n  Actual: 1", error.message
  end

  def test_assert_not_called_is_alias_for_refute_called
    assert method(:assert_not_called).eql?(method(:refute_called))
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

  def test_assert_called_with_failure_because_method_has_not_been_called_with_expected_arguments
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

  def test_assert_called_with_an_array_as_expected_argument
    assert_called_with(@post, :add_comment, [[["Thanks for sharing this."]]]) do
      @post.add_comment(["Thanks for sharing this."])
    end

    assert_called_with(@post, :add_comment, [[["Thanks for sharing this.", "Thanks!"]]]) do
      @post.add_comment(["Thanks for sharing this.", "Thanks!"])
    end
  end

  def test_assert_called_with_expected_arguments_as_arrays
    assert_called_with(@post, :add_comment, [[["Thanks for sharing this."], ["Thanks!"]]]) do
      @post.add_comment(["Thanks for sharing this."], ["Thanks!"])
    end
  end

  def test_assert_called_with_multiple_expected_arguments_as_arrays
    assert_called_with(@post, :add_comment, [[["Thanks for sharing this."]], [["Thanks!"]]]) do
      @post.add_comment(["Thanks for sharing this."])
      @post.add_comment(["Thanks!"])
    end
  end

  def test_assert_called_with_expected_arguments_as_array_and_one_non_array_object
    assert_called_with(@post, :add_comment, [["Thanks for sharing this."], {body: "Thanks!"}]) do
      @post.add_comment(["Thanks for sharing this."], {body: "Thanks!"})
    end
  end

  def test_assert_called_with_multiple_expected_arguments_as_array_and_one_non_array_object
    assert_called_with(@post, :add_comment, [[["Thanks for sharing this."]], [{body: "Thanks!"}]]) do
      @post.add_comment(["Thanks for sharing this."])
      @post.add_comment({body: "Thanks!"})
    end
  end

  def test_assert_called_on_instance_of_with_defaults_to_expect_once
    assert_called_on_instance_of(Post, :title) do
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

  def test_assert_called_on_instance_of_failure_because_method_has_not_been_called
    error = assert_raises(Minitest::Assertion) do
      assert_called_on_instance_of(Post, :title) do
        @post.body
      end
    end

    assert_equal "Expected title to be called 1 times, but was called 0 times.\nExpected: 1\n  Actual: 0", error.message
  end

  def test_assert_called_on_instance_of_failure_because_method_has_been_called_more_than_expected_times
    error = assert_raises(Minitest::Assertion) do
      assert_called_on_instance_of(Post, :title) do
        @post.title
        @post.title
      end
    end

    assert_equal "Expected title to be called 1 times, but was called 2 times.\nExpected: 1\n  Actual: 2", error.message
  end

  def test_assert_called_on_instance_of_failure_with_message
    error = assert_raises(Minitest::Assertion) do
      assert_called_on_instance_of(Post, :title, "Message") do
        @post.body
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

  def test_refute_called_on_instance_of
    refute_called_on_instance_of(Post, :title) do
      @post.body
    end
  end

  def test_refute_called_on_instance_of_failure_because_method_has_been_called
    error = assert_raises(Minitest::Assertion) do
      refute_called_on_instance_of(Post, :add_comment) do
        @post.add_comment("Thanks for sharing this.")
      end
    end

    assert_equal "Expected add_comment to be called 0 times, but was called 1 times.\nExpected: 0\n  Actual: 1", error.message
  end

  def test_refute_called_on_instance_of_failure_with_message
    error = assert_raises(Minitest::Assertion) do
      refute_called_on_instance_of(Post, :title, "Message") do
        @post.title
      end
    end

    assert_equal "Message.\nExpected title to be called 0 times, but was called 1 times.\nExpected: 0\n  Actual: 1", error.message
  end

  def test_refute_called_on_instance_of_nesting
    refute_called_on_instance_of(Post, :title) do
      refute_called_on_instance_of(Post, :body) do
        @post.add_comment("Thanks for sharing this.")
      end
    end
  end

  def test_assert_not_called_on_instance_of_is_alias_for_refute_called
    assert method(:assert_not_called_on_instance_of).eql?(method(:refute_called_on_instance_of))
  end
end
