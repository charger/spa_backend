require 'spec_helper'

describe 'Post API' do
  describe 'GET /post/:id' do
    let(:post) { create :post }

    it 'gets a specific post' do
      get "/api/posts/#{post.id}"

      expect(response).to be_success
      expect(json['body']).to eq post.body
    end
  end

  describe 'GET /posts' do
    before do
      create :post, title: 'Title #1'
      create :post, title: 'Title #2'
    end

    it 'gets all posts' do
      get '/api/posts'

      expect(response).to be_success
      expect(json.count).to eq 2
      expect(json[0]['title']).to eq 'Title #1'
      expect(json[1]['title']).to eq 'Title #2'
    end
  end

  describe 'POST /posts' do
    it 'creates a post' do
      post '/api/posts', { post: { title: 'Joke', body: 'Knock knock...' } }

      expect(response).to be_success
      expect(json['title']).to eq 'Joke'
      expect(Post.find(json['id']).title).to eq 'Joke'
    end
  end

  describe 'PATCH /posts/:id' do
    let(:post) { create :post }

    it 'update a post' do
      patch "/api/posts/#{post.id}", { post: { title: 'Joke' } }

      expect(response).to be_success
      expect(json['title']).to eq 'Joke'
      expect(Post.find(json['id']).title).to eq 'Joke'
    end
  end

  describe 'DELETE /posts/:id' do
    it 'update a post' do
      post = create :post
      delete "/api/posts/#{post.id}"

      expect(response).to be_success
      expect(Post.find_by_id(post.id)).to be nil
    end
  end
end
