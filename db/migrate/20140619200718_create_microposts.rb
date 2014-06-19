class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
		# Expect to retrieve all microposts associated with given user id in reverse order
	    	# place an index on both columns involved in search
	    	# Placing both :user_id and :created_at in an array creates a
	    	# 'multiple key index' - Active Record users BOTH keys at SAME TIME
  end
end
