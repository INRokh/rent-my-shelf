USER_COUNT = 15
SPACES_COUNT_PER_USER = 6

Faker::Config.locale = "en-AU"

product_types = ["food", "coffee", "drinks", "clothes", "accessories", "jewelries", "home", "electronics", "gadgets"]

for pt in product_types
  Product.create(name: pt)
end

for i in 1..USER_COUNT
  user = User.create(
    full_name: Faker::Name.first_name + " " + Faker::Name.last_name,
    email: Faker::Internet.email,
    password: Faker::Internet.password,
  )
  for i in 1..rand(SPACES_COUNT_PER_USER)
    space_type = Space.space_types.to_a.sample[0]
    title = "Default Space Title"
    description = "Defualt Space Description"
    case space_type
    when "shop"
      title = Faker::Company.name
      description = Faker::Company.catch_phrase
    else
      title = Faker::Restaurant.name
      description = Faker::Restaurant.description
    end
    products = []
    for pi in 1..product_types.length
      products << Product.where(name: product_types.sample).first
    end
    space = Space.create(
      user: user,
      title: title,
      description: description,
      space_type: space_type,
      size: Space.sizes.to_a.sample[0],
      address: Faker::Address.street_address,
      post_code: ["2000", "2010", "2020", "2030"].sample,
      price: rand(1..50)*10,
      contact_info: Faker::Name.first_name + " " + Faker::Name.last_name + Faker::PhoneNumber.phone_number,
      is_active: rand(1..10) > 2,
      products: products
    )
    puts space.errors unless space

    space_image_url = Faker::LoremFlickr.image(size: "1200x900", search_terms: [space_type])
    puts "Loading #{space_image_url}"
    tmp_image = Down.download(space_image_url)
    puts "Saving #{space_image_url}"
    space.image.attach(io: tmp_image , filename: File.basename(tmp_image.path))
  end
end

