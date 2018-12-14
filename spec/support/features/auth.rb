module Features
  module Auth
    module Helper

      def authenticate(user)
        visit new_admin_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Login'
      end

    end
  end
end
