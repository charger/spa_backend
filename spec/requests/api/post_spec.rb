require 'spec_helper'
require 'json_web_token'

describe 'Post API' do
  let(:headers){ { 'Authorization' => "Bearer #{JsonWebToken.encode({ user_id: Rails.application.secrets.user_id })}" } }

  describe 'GET /post/:id' do
    let(:post) { create :post }

    context 'when valid token provided' do
      it 'gets a specific post' do
        get "/api/posts/#{post.id}", nil, headers

        expect(response).to be_success
        expect(json['body']).to eq post.body
      end
    end

    context 'when invalid token provided' do
      it 'gets a error 401' do
        get "/api/posts/#{post.id}", nil

        expect(response.code).to eq '401'
      end
    end
  end

  describe 'GET /posts' do
    before do
      create :post, title: 'Title #1', created_at: 1.day.ago
      create :post, title: 'Title #2', body: 'Foo bar'
    end

    context 'when no filter provided' do
      it 'gets all posts' do
        get '/api/posts', nil, headers

        expect(response).to be_success
        expect(json.count).to eq 2
        expect(json[0]['title']).to eq 'Title #1'
        expect(json[1]['title']).to eq 'Title #2'
      end
    end

    context 'when filter provided' do
      it 'gets filtered posts' do
        get '/api/posts', {filter: 'bar'}, headers

        expect(response).to be_success
        expect(json.count).to eq 1
        expect(json[0]['title']).to eq 'Title #2'
      end
    end

    context 'when paginated' do
      it 'gets only one page' do
        create_list :post, 6
        get '/api/posts', nil, headers

        expect(response).to be_success
        expect(json.count).to eq 5

        get '/api/posts', {page: 2}, headers

        expect(response).to be_success
        expect(json.count).to eq 3
      end
    end

    context 'when order provided' do
      it 'gets ordered posts' do
        get '/api/posts', {order: 'created_at', order_direction: 'desc'}, headers

        expect(response).to be_success
        expect(json.count).to eq 2
        expect(json[0]['title']).to eq 'Title #2'
        expect(json[1]['title']).to eq 'Title #1'

        get '/api/posts', {order: 'created_at', order_direction: 'asc'}, headers
        expect(json[0]['title']).to eq 'Title #1'
        expect(json[1]['title']).to eq 'Title #2'

        get '/api/posts', {order: 'created_at', order_direction: 'wrong'}, headers
        expect(json[0]['title']).to eq 'Title #1'
        expect(json[1]['title']).to eq 'Title #2'
      end
    end


  end

  describe 'POST /posts' do
    it 'creates a post' do
      post '/api/posts', { post: { title: 'Joke', body: 'Knock knock...' } }, headers

      expect(response).to be_success
      expect(json['title']).to eq 'Joke'
      expect(Post.find(json['id']).title).to eq 'Joke'
    end
  end

  describe 'PATCH /posts/:id' do
    let(:post) { create :post }

    it 'update a post' do
      patch "/api/posts/#{post.id}", { post: { title: 'Joke' } }, headers

      expect(response).to be_success
      expect(json['title']).to eq 'Joke'
      expect(Post.find(json['id']).title).to eq 'Joke'
    end
  end

  describe 'DELETE /posts/:id' do
    it 'update a post' do
      post = create :post
      delete "/api/posts/#{post.id}", nil, headers

      expect(response).to be_success
      expect(Post.find_by_id(post.id)).to be nil
    end
  end
end
