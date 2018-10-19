require "minitest"
require "minitest/assertions"
require "minitest/mock"

module Minitest
  # Provides method call assertions for minitest
  #
  # Imagine we have model +Post+:
  #
  #   class Post
  #     attr_accessor :title, :body
  #     attr_reader :comments
  #
  #     def initialize(title: "", body: "", comments: [])
  #       @title = title
  #       @body = body
  #       @comments = comments
  #     end
  #
  #     def add_comment(comment)
  #       @comments << comment
  #
  #       "Thank you!"
  #     end
  #   end
  #
  # and variable +@post+ that reffers to instance of +Post+:
  #
  #   def setup
  #     @post = Post.new(
  #       title: "What is new in Rails 6.0",
  #       body: "https://bogdanvlviv.com/posts/ruby/rails/what-is-new-in-rails-6_0.html",
  #       comments: [
  #         "Looking really good.",
  #         "I really like this post."
  #       ]
  #     )
  #   end
  module Assertions
    # Asserts that the method will be called on the +object+ in the block:
    #
    #   assert_called(@post, :title) do
    #     @post.title
    #   end
    #
    # In order to assert that the method will be called multiple times on the +object+ in the block set +:times+ option:
    #
    #   assert_called(@post, :title, times: 2) do
    #     @post.title
    #     @post.title
    #   end
    #
    # You can stub the return value of the method in the block via +:returns+ option:
    #
    #   assert_called(@post, :title, returns: "What is new in Rails 5.2") do
    #     assert_equal "What is new in Rails 5.2", @object.title
    #   end
    #
    #   assert_equal "What is new in Rails 6.0", @object.title
    def assert_called(object, method_name, message = nil, times: 1, returns: nil)
      times_called = 0

      object.stub(method_name, proc { times_called += 1; returns }) { yield }

      error = "Expected #{method_name} to be called #{times} times, but was called #{times_called} times"
      error = "#{message}.\n#{error}" if message
      assert_equal times, times_called, error
    end

    # Asserts that the method will not be called on the +object+ in the block:
    #
    #   refute_called(@post, :title) do
    #     @post.body
    #   end
    def refute_called(object, method_name, message = nil, &block)
      assert_called(object, method_name, message, times: 0, &block)
    end

    alias assert_not_called refute_called

    # Asserts that the method will be called with the +arguments+ on the +object+ in the block:
    #
    #   assert_called_with(@post, :add_comment, ["Thanks for sharing this."]) do
    #     @post.add_comment("Thanks for sharing this.")
    #   end
    #
    # You can stub the return value of the method in the block via +:returns+ option:
    #
    #   assert_called_with(@post, :add_comment, ["Thanks for sharing this."], returns: "Thanks!") do
    #     assert_equal "Thanks!", @post.add_comment("Thanks for sharing this.")
    #   end
    #
    #   assert_equal "Thank you!", @post.add_comment("Thanks for sharing this.")
    #
    # You can also assert that the method will be called with different +arguments+ on the +object+ in the block:
    #
    #   assert_called_with(@post, :add_comment, [["Thanks for sharing this."], ["Thanks!"]]) do
    #     @post.add_comment("Thanks for sharing this.")
    #     @post.add_comment("Thanks!")
    #   end
    def assert_called_with(object, method_name, arguments, returns: nil)
      mock = Minitest::Mock.new

      if arguments.all? { |argument| argument.is_a?(Array) }
        arguments.each { |argument| mock.expect(:call, returns, argument) }
      else
        mock.expect(:call, returns, arguments)
      end

      object.stub(method_name, mock) { yield }

      mock.verify
    end

    # Asserts that the method will be called on an instance of the +klass+ in the block:
    #
    #   assert_called_on_instance_of(Post, :title) do
    #     @post.title
    #   end
    #
    # In order to assert that the method will be called multiple times on an instance of the +klass+ in the block set +:times+ option:
    #
    #   assert_called_on_instance_of(Post, :title, times: 2) do
    #     @post.title
    #     @post.title
    #   end
    #
    # You can stub the return value of the method in the block via +:returns+ option:
    #
    #   assert_called_on_instance_of(Post, :title, returns: "What is new in Rails 5.2") do
    #     assert_equal "What is new in Rails 5.2", @post.title
    #   end
    #
    #   assert_equal "What is new in Rails 6.0", @post.title
    #
    # Use nesting of the blocks in order assert that the several methods will be called on an instance of the +klass+ in the block:
    #
    #   assert_called_on_instance_of(Post, :title, times: 3) do
    #     assert_called_on_instance_of(Post, :body, times: 2) do
    #       @post.title
    #       @post.body
    #       @post.title
    #       @post.body
    #       @post.title
    #     end
    #   end
    def assert_called_on_instance_of(klass, method_name, message = nil, times: 1, returns: nil)
      times_called = 0

      klass.send(:define_method, "stubbed_#{method_name}") do |*|
        times_called += 1

        returns
      end

      klass.send(:alias_method, "original_#{method_name}", method_name)
      klass.send(:alias_method, method_name, "stubbed_#{method_name}")

      yield

      error = "Expected #{method_name} to be called #{times} times, but was called #{times_called} times"
      error = "#{message}.\n#{error}" if message

      assert_equal times, times_called, error
    ensure
      klass.send(:alias_method, method_name, "original_#{method_name}")
      klass.send(:undef_method, "original_#{method_name}")
      klass.send(:undef_method, "stubbed_#{method_name}")
    end

    # Asserts that the method will not be called on an instance of the +klass+ in the block:
    #
    #   refute_called_on_instance_of(Post, :title) do
    #     @post.body
    #   end
    #
    # Use nesting of the blocks in order assert that the several methods will not be called on an instance of the +klass+ in the block:
    #
    #   refute_called_on_instance_of(Post, :title) do
    #     refute_called_on_instance_of(Post, :body) do
    #       @post.add_comment("Thanks for sharing this.")
    #     end
    #   end
    def refute_called_on_instance_of(klass, method_name, message = nil, &block)
      assert_called_on_instance_of(klass, method_name, message, times: 0, &block)
    end

    alias assert_not_called_on_instance_of refute_called_on_instance_of
  end
end
