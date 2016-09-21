require 'presenters/v3/base_presenter'

module VCAP::CloudController
  module Presenters
    module V3
      class TaskPresenter < BasePresenter
        def to_hash
          hide_secrets({
            guid:                  task.guid,
            sequence_id:           task.sequence_id,
            name:                  task.name,
            command:               task.command,
            state:                 task.state,
            memory_in_mb:          task.memory_in_mb,
            environment_variables: task.environment_variables || {},
            result:                { failure_reason: task.failure_reason },
            created_at:            task.created_at,
            updated_at:            task.updated_at,
            droplet_guid:          task.droplet_guid,
            links:                 build_links
          })
        end

        private

        def task
          @resource
        end

        def build_links
          {
            self:    { href: "/v3/tasks/#{task.guid}" },
            app:     { href: "/v3/apps/#{task.app.guid}" },
            droplet: { href: "/v3/droplets/#{task.droplet_guid}" },
          }
        end

        def hide_secrets(hash)
          unless @show_secrets
            hash.delete(:environment_variables)
            hash.delete(:command)
          end
          hash
        end
      end
    end
  end
end
