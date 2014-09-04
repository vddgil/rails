require 'translation_io/client/sync_operation/update_and_collect_pot_file_step'
require 'translation_io/client/sync_operation/create_yaml_pot_file_step'

module TranslationIO
  class Client
    class SyncOperation < BaseOperation
      def run(purge = false)
        config = TranslationIO.config

        haml_source_files = config.haml_source_files
        slim_source_files = config.slim_source_files

        BaseOperation::DumpHamlGettextKeysStep.new(haml_source_files).run
        BaseOperation::DumpSlimGettextKeysStep.new(slim_source_files).run

        source_files      = config.source_files
        pot_path          = config.pot_path
        source_locale     = config.source_locale
        target_locales    = config.target_locales
        locales_path      = config.locales_path
        yaml_locales_path = config.yaml_locales_path
        yaml_file_paths   = config.yaml_file_paths

        UpdateAndCollectPotFileStep.new(pot_path, source_files).run(params)
        CreateYamlPotFileStep.new(source_locale, yaml_file_paths).run(params)

        if purge
          params['purge'] = 'true'
        end

        uri             = URI("http://#{client.endpoint}/projects/#{client.api_key}/sync")
        parsed_response = BaseOperation.perform_request(uri, params)

        unless parsed_response.nil?
          BaseOperation::SaveNewPoFilesStep.new(target_locales, locales_path, parsed_response).run
          BaseOperation::CreateNewMoFilesStep.new(locales_path).run
          BaseOperation::SaveNewYamlFilesStep.new(target_locales, yaml_locales_path, parsed_response).run
          BaseOperation::SaveSpecialYamlFilesStep.new(source_locale, target_locales, yaml_locales_path, yaml_file_paths).run
        end

        cleanup
      end
    end
  end
end
