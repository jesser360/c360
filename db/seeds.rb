# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
  # Item.delete_all
  # items = Item.create([{item_name: 'Isolate', price: 10, image: 'https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/05/gizmodo-high-tech-620x349.jpg',user:User.find(5)}, {item_name: 'Distillate', price: 25, image: 'https://i.pinimg.com/736x/46/cb/c7/46cbc706585b465471022f1a121ac5ab--weed-art-smoking-weed.jpg',user:User.find(5)}, {item_name: 'Crude Oil', price: 50, image: 'https://greatist.com/sites/default/files/styles/article_main/public/Marijuana_Spot_Illustration2.png?itok=QpDo7dUK',user:User.find(5)}])
  Review.delete_all
  Address.delete_all
  UserOrder.delete_all
  BulkOrder.delete_all
  Item.delete_all
  User.delete_all

  seller = User.create({email:'seller@yahoo.com',password:'123',is_vendor:true,email_confirmed:true,zipcode:80014,company_name:'CannaSupply',city:'Denver',state:'CO'})
  buyer = User.create({email:'buyer@yahoo.com',password:'123',is_vendor:false,email_confirmed:true,zipcode:94618})


  item = Item.create({item_name: "CBD Oil",user: seller, description: "Headache and body pain relief", rating: 0, rating_count: 0})
  item.avatar = File.open('/Users/jesserosenbloom/code/c360/app/assets/images/cbd_oil.png')
  item.save!

  batch = BulkOrder.create({percent_filled: 0,max_amount: 400, expire_date: (Time.now + 7.days), completed: false, item: item, market_price: 12, wholesale_price: 10, item_name: "CBD Oil", description: "Headache and body pain relief", published: true, buyer_count: 0, token: "GMBMLCCyFv5fUX6qbNNYhpdU"})
