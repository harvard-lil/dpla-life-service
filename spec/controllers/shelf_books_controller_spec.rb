require 'spec_helper'

describe ShelfBooksController do
  let(:user) { create :user }
  let(:shelf) { create :shelf }
  let(:shelf_book) { create :shelf_book }

  describe '#create' do
    context 'when not logged in' do
      before do
        post :create, shelf_id: shelf.id, id: 1
      end

      it { should respond_with 401 }
      it { should render_template nil }
      specify { shelf.reload.book_ids.should be_blank }
      specify { shelf.reload.shelf_books.should be_blank }
    end

    context 'when shelf does not belong to user' do
      before do
        set_token user.token
        post :create, shelf_id: shelf.id, id: 1
      end

      it { should respond_with 401 }
      it { should render_template nil }
      specify { shelf.reload.book_ids.should be_blank }
      specify { shelf.reload.shelf_books.should be_blank }
    end

    context 'when shelf belongs to user' do
      before do
        set_token shelf.user.token
        post :create, shelf_id: shelf.id, id: 1
      end

      it { should respond_with 201 }
      it { should render_template 'shelves/show' }
      it { should assign_to(:shelf).with shelf }
      specify { shelf.reload.book_ids.should eq ['1'] }
      specify { shelf.reload.shelf_books.first.book_id.should eq '1' }
    end
  end

  describe '#destroy' do
    context 'when not logged in' do
      before do
        delete :destroy, shelf_id: shelf_book.shelf.id, id: shelf_book.book_id
      end

      it { should respond_with 401 }
      it { should render_template nil }
      specify { ShelfBook.count.should eq 1 }
      specify { shelf_book.shelf.book_ids.should include shelf_book.book_id }
    end

    context 'when shelf does not belong to user' do
      before do
        set_token user.token
        delete :destroy, shelf_id: shelf_book.shelf.id, id: shelf_book.book_id
      end

      it { should respond_with 401 }
      it { should render_template nil }
      specify { ShelfBook.count.should eq 1 }
      specify { shelf_book.shelf.book_ids.should include shelf_book.book_id }
    end

    context 'when shelf belongs to user' do
      before do
        set_token shelf_book.shelf.user.token
        delete :destroy, shelf_id: shelf_book.shelf.id, id: shelf_book.book_id
      end

      it { should respond_with 204 }
      it { should render_template nil }
      specify { ShelfBook.count.should eq 0 }
      specify {
        shelf_book.shelf.reload.book_ids.should_not include shelf_book.book_id
      }
    end
  end
end
