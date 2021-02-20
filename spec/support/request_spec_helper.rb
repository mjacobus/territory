# frozen_string_literal: true

module RequestSpecHelper
  # rubocop:disable Metrics/MethodLength
  def self.included(base)
    base.class_eval do
      let(:regular_user) { User.new(id: 1, enabled: true, master: false, avatar: avatar) }
      let(:current_user) { regular_user }
      let(:admin_user) { User.new(id: 2, enabled: true, master: true, avatar: avatar) }
      let(:skip_login) { false }
      let(:avatar) { 'https://foo.com/bar.png'  }
      # still not sure how to use sessions here
      # https://stackoverflow.com/questions/53447837/set-a-session-var-in-rspec-request-spec
      let(:session) { {} }

      before do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(session)
        unless skip_login
          login_user(current_user)
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def login_user(user)
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
    # rubocop:enable RSpec/AnyInstance
  end
end
