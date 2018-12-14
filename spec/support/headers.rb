module Headers

  module Helper

    def should_robot
      expect(response.headers['X-Robots-Tag']).to be_nil
    end

    def should_norobot
      expect(response.headers['X-Robots-Tag']).to(eql('noindex,nofollow'))
    end

  end

end
