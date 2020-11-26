# Modules

---

- a class can only subclass from 1 superclass
- This makes it difficult to model a problem domain

![img](https://d1b1wr57ag5rdp.cloudfront.net/images/oop/lesson2/module_class_hierarchy.png)

- we don't want to repeat the swim class for both the dog and fish class
- The way ruby supports *multiple inheritance* is through **Modules** by mixing in behaviors with other classes
- a class can only subclass from one parent but can mix in as many modules as it likes 

```ruby
module Swim
  def swim
    "swimming!"
  end
end

class Dog
  include Swim
  # ... rest of class omitted
end

class Fish
  include Swim
  # ... rest of class omitted
end
```

- `swim` method is now only available to both `Dog` and `Fish` classes
- mixing in modules does affect the lookup path