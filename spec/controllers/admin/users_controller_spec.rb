require 'spec_helper'

describe Admin::UsersController do

  let(:user) { Fabricate(:user, role: User::Role::ADMIN) }

  before :each do
    request.env['HTTPS'] = 'on'
  end

  before(:each) do
    authenticate(user)
  end

  describe 'GET #edit' do
    it 'it successful' do
      get :edit
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'redirects if successful' do
        expect {
          patch :update, params: { user: { name: user.name.reverse } }
          expect(response).to redirect_to(admin_path)
        }.to change { user.reload.name }
      end
    end

    context 'with invalid parameters' do
      it 're-renders the "edit" template' do
        expect {
          patch :update, params: { user: { name: '' } }
          expect(response).to render_template('edit')
        }.to_not change { user.reload.name }
      end
    end
  end

end
