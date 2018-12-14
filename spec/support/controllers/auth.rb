module Controllers
  module Auth
    module Helper

      def authenticate(user)
        allow(controller).to receive(:user) { user }
        allow(controller).to receive(:authenticated?) { true }
      end

      def deauthenticate
        allow(controller).to receive(:authenticated?) { false }
      end

      def should_admin!
        case
        when request.format.html?
          expect(response).to(redirect_to(new_admin_session_path))
        end

        expect(flash[:alert]).to eql('You must be an admin.')
      end

      def should_authenticate!
        case
        when request.format.html?
          expect(response).to(redirect_to(root_path))
        end

        expect(flash[:alert]).to eql('You must be logged in.')
      end

      def should_deauthenticate!
        case
        when request.format.html?
          expect(response).to redirect_to(root_path)
        end

        expect(flash[:alert]).to eql('You must be logged out.')
      end

      def should_be_authenticated
        expect(cookies[:user]).to_not be_nil
      end

      def should_be_deauthenticated
        expect(cookies[:user]).to be_nil
      end

    end
  end
end
