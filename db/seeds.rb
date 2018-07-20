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
  reviewer = User.create({email:'reviewer@yahoo.com',password:'123',is_vendor:false,email_confirmed:true,zipcode:94618})


  item1 = Item.create({item_name: "CBD Oil",user: seller, description: "Headache and body pain relief", rating: 3, rating_count: 1})
  # item1.avatar = File.open('/Users/jesse/code/c360/app/assets/images/cbd_oil.png')
  item1.save!
  item2 = Item.create({item_name: "CBD Concentrate Oil",user: seller, description: "Great for body aches and feeling good", rating: 5, rating_count: 1})
  # item2.avatar = File.open('/Users/jesse/code/c360/app/assets/images/cbd-oil2.png')
  item2.save!
  item3 = Item.create({item_name: "Isolate",user: seller, description: "Pure Isolate with only CBD ingredients", rating: 4, rating_count: 1})
  # item3.avatar = File.open('/Users/jesse/code/c360/app/assets/images/isolate.png')
  item3.save!
  item4 = Item.create({item_name: "Distillate",user: seller, description: "CBD Distillate made from high grade Hemp plants", rating: 2, rating_count: 1})
  # item4.avatar = File.open('/Users/jesse/code/c360/app/assets/images/distillate.png')
  item4.save!

  bull_batch = BulkOrder.create({percent_filled: 0,max_amount: 400, expire_date: (Time.now), completed: true, item: item1, market_price: 11, wholesale_price: 7, published: true, buyer_count: 0, token: "GMBMLCCyFv5fUX6qbNNYhpdD"})
  batch1 = BulkOrder.create({percent_filled: 0,max_amount: 400, expire_date: (Time.now + 7.days), completed: false, item: item1, market_price: 11, wholesale_price: 7, published: true, buyer_count: 0, token: "GMBMLCCyFv5fUX6qbNNYhpdU"})
  batch2 = BulkOrder.create({percent_filled: 0,max_amount: 200, expire_date: (Time.now + 7.days), completed: false, item: item2, market_price: 12, wholesale_price: 10, published: true, buyer_count: 0, token: "24bMtDf8g2hAVJAxpHpEW0fT"})
  batch3 = BulkOrder.create({percent_filled: 0,max_amount: 750, expire_date: (Time.now + 7.days), completed: false, item: item3, market_price: 15, wholesale_price: 11, published: true, buyer_count: 0, token: "pHpEW0fTpHpEW0fTpHpEW0fT"})
  batch4 = BulkOrder.create({percent_filled: 0,max_amount: 1000, expire_date: (Time.now + 7.days), completed: false, item: item4, market_price: 18, wholesale_price: 16, published: true, buyer_count: 0, token: "jcKp+8ENjcKp+8ENjcKp+8EN"})

  user_order1 = UserOrder.create(quantity: 282,total_price: 1974,user:buyer,bulk_order:bull_batch)
  user_order2 = UserOrder.create(quantity: 282,total_price: 1974,user:buyer,bulk_order:bull_batch)
  user_order3 = UserOrder.create(quantity: 282,total_price: 1974,user:buyer,bulk_order:bull_batch)
  user_order4 = UserOrder.create(quantity: 282,total_price: 1974,user:buyer,bulk_order:bull_batch)

  review1 = Review.create({rating: 3,title: "Loveley product",
  body:"I used this product all day every day, Oil was a little glassy but very nice",
  user: reviewer,item:item1,bulk_order: bull_batch,user_order:user_order1})
  review2 = Review.create({rating: 5,title: "Must Have!",
  body:"This is the best quality oil I have used for a while, would reccommend to everyone",
  user: reviewer,item:item2,bulk_order: bull_batch,user_order:user_order2})
  review3 = Review.create({rating: 4,title: "Really good batch of Isolate",
  body:"It was delivered on time and packaged nicely was well",
  user: reviewer,item:item3,bulk_order: bull_batch,user_order:user_order3})
  review4 = Review.create({rating: 2,title: "Dont Buy this",
  body:"This gave me a headache and smelled funny",
  user: reviewer,item:item4,bulk_order: bull_batch,user_order:user_order4})
