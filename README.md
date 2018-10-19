# minitest-mock_expectations

Provides method call assertions for minitest

## Installation

Add this line to your application's Gemfile:

```ruby
gem "minitest-mock_expectations"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install minitest-mock_expectations
```

## Usage

```ruby
require "minitest/mock_expectations"
```

Imagine we have model `Post`:

```ruby
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
```

and variable `@post` that reffers to instance of `Post`:

```ruby
def setup
  @post = Post.new(
    title: "What is new in Rails 6.0",
    body: "https://bogdanvlviv.com/posts/ruby/rails/what-is-new-in-rails-6_0.html",
    comments: [
      "Looking really good.",
      "I really like this post."
    ]
  )
end
```

### assert_called(object, method_name, message = nil, times: 1, returns: nil)

Asserts that the method will be called on the `object` in the block:

```ruby
assert_called(@post, :title) do
  @post.title
end
```

In order to assert that the method will be called multiple times on the `object` in the block set `:times` option:

```ruby
assert_called(@post, :title, times: 2) do
  @post.title
  @post.title
end
```

You can stub the return value of the method in the block via `:returns` option:

```ruby
assert_called(@post, :title, returns: "What is new in Rails 5.2") do
  assert_equal "What is new in Rails 5.2", @object.title
end

assert_equal "What is new in Rails 6.0", @object.title
```

### refute_called(object, method_name, message = nil, &block)

Asserts that the method will not be called on the `object` in the block:

```ruby
refute_called(@post, :title) do
  @post.body
end
```

### assert_not_called

Alias for `refute_called`.

### assert_called_with(object, method_name, arguments, returns: nil)

Asserts that the method will be called with the `arguments` on the `object` in the block:

```ruby
assert_called_with(@post, :add_comment, ["Thanks for sharing this."]) do
  @post.add_comment("Thanks for sharing this.")
end
```

You can stub the return value of the method in the block via `:returns` option:

```ruby
assert_called_with(@post, :add_comment, ["Thanks for sharing this."], returns: "Thanks!") do
  assert_equal "Thanks!", @post.add_comment("Thanks for sharing this.")
end

assert_equal "Thank you!", @post.add_comment("Thanks for sharing this.")
```

You can also assert that the method will be called with different `arguments` on the `object` in the block:

```ruby
assert_called_with(@post, :add_comment, [["Thanks for sharing this."], ["Thanks!"]]) do
  @post.add_comment("Thanks for sharing this.")
  @post.add_comment("Thanks!")
end
```

### assert_called_on_instance_of(klass, method_name, message = nil, times: 1, returns: nil)

Asserts that the method will be called on an instance of the `klass` in the block:

```ruby
assert_called_on_instance_of(Post, :title) do
  @post.title
end
```

In order to assert that the method will be called multiple times on an instance of the `klass` in the block set `:times` option:

```ruby
assert_called_on_instance_of(Post, :title, times: 2) do
  @post.title
  @post.title
end
```

You can stub the return value of the method in the block via `:returns` option:

```ruby
assert_called_on_instance_of(Post, :title, returns: "What is new in Rails 5.2") do
  assert_equal "What is new in Rails 5.2", @post.title
end

assert_equal "What is new in Rails 6.0", @post.title
```

Use nesting of the blocks in order assert that the several methods will be called on an instance of the `klass` in the block:

```ruby
assert_called_on_instance_of(Post, :title, times: 3) do
  assert_called_on_instance_of(Post, :body, times: 2) do
    @post.title
    @post.body
    @post.title
    @post.body
    @post.title
  end
end
```

### refute_called_on_instance_of(klass, method_name, message = nil, &block)

Asserts that the method will not be called on an instance of the `klass` in the block:

```ruby
refute_called(@post, :title) do
  @post.body
end
```

Use nesting of the blocks in order assert that the several methods will not be called on an instance of the `klass` in the block:

```ruby
refute_called_on_instance_of(Post, :title) do
  refute_called_on_instance_of(Post, :body) do
  end
end
```

### assert_not_called_on_instance_of

Alias for `refute_called_on_instance_of`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bogdanvlviv/minitest-mock_expectations. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://contributor-covenant.org) code of conduct.

## Code Status

[![travis-ci](https://api.travis-ci.org/bogdanvlviv/minitest-mock_expectations.svg?branch=master)](https://travis-ci.org/bogdanvlviv/minitest-mock_expectations)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
