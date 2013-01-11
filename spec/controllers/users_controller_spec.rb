require 'spec_helper'

describe UsersController do
  describe '#create' do
    context 'with valid user attributes' do
      before do
        post :create, user: attributes_for(:user)
      end

      it { should respond_with 201 }
      it { should render_template :session }
      it { should assign_to :user }
      specify { User.count.should eq 1 }
    end

    context 'with invalid user attributes' do
      before do
        post :create, user: attributes_for(:user, email: nil)
      end

      it { should respond_with 422 }
      it { should render_template 'errors/422' }
    end
  end

  describe '#destroy' do
    let(:user) { create :user }

    context 'with a valid session token' do
      before do
        set_token user.token
        delete :destroy, id: user.id
      end

      it { should respond_with 204 }
      it { should render_template nil }
      specify { User.count.should eq 0 }
    end

    context 'with an invalid session token' do
      before do
        set_token 'nonsense'
        delete :destroy, id: user.id
      end

      it { should respond_with 401 }
      it { should render_template nil }
      specify { User.count.should eq 1 }
    end
  end
end