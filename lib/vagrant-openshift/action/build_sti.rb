#--
# Copyright 2013 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++

module Vagrant
  module Openshift
    module Action
      class BuildSti
        include CommandHelper

        def initialize(app, env, options)
          @app = app
          @env = env
          @options = options
        end

        def call(env)

            cmd = %{
echo "Performing sti build..."
set -e
hack/verify-gofmt.sh
hack/build-go.sh
hack/build-images.sh
}
          unless @options[:force]
            cmd = sync_bash_command('source-to-image', cmd)
          end
          do_execute(env[:machine], cmd)

          @app.call(env)
        end

      end
    end
  end
end
