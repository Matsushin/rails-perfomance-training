ActiveRecord::Base::transaction do
  unless Category.exists?
    %w[仕事 学習 プライベート その他].each do |name|
      Category.create!(name: name)
    end
  end
end