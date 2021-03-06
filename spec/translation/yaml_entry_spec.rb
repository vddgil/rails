TranslationIO::YamlEntry

require 'spec_helper'

describe TranslationIO::YamlEntry do
  describe '#string?' do
    it  do
      TranslationIO::YamlEntry.string?('en.some.key', 'hello').should be true
      TranslationIO::YamlEntry.string?('en.some.key', ''     ).should be true

      TranslationIO::YamlEntry.string?('', 'hello'          ).should be false
      TranslationIO::YamlEntry.string?('en.some.key', 42    ).should be false
      TranslationIO::YamlEntry.string?('en.some.key', true  ).should be false
      TranslationIO::YamlEntry.string?('en.some.key', false ).should be false
      TranslationIO::YamlEntry.string?('en.some.key', :hello).should be false
    end
  end

  describe '#from_locale?' do
    it do
      TranslationIO::YamlEntry.from_locale?('en.some.key', 'en').should be true
      TranslationIO::YamlEntry.from_locale?('en.some.key', 'fr').should be false
    end
  end

  describe '#ignored?' do
    it do
      TranslationIO::YamlEntry.ignored?('en.faker.yo').should be true
      TranslationIO::YamlEntry.ignored?('en.yo').should be false

      TranslationIO.config.ignored_key_prefixes = ['world']
      TranslationIO::YamlEntry.ignored?('en.world.hello').should be true
    end
  end

  describe '#localization?' do
    it do
      TranslationIO::YamlEntry.localization?('en.yo', 'Hello').should be false
      TranslationIO::YamlEntry.localization?('', 'hello'     ).should be false

      TranslationIO::YamlEntry.localization?('en.some.key', 42    ).should be true
      TranslationIO::YamlEntry.localization?('en.some.key', true  ).should be true
      TranslationIO::YamlEntry.localization?('en.some.key', false ).should be true
      TranslationIO::YamlEntry.localization?('en.some.key', :hello).should be true

      TranslationIO::YamlEntry.localization?('en.date.formats.default', '%Y').should be true
      TranslationIO::YamlEntry.localization?('en.date.order[0]', :year      ).should be true
      TranslationIO::YamlEntry.localization?('en.date.order[1]', :month     ).should be true
      TranslationIO::YamlEntry.localization?('en.date.order[2]', :day       ).should be true

      TranslationIO::YamlEntry.localization?('en.i18n.transliterate.rule.æ', "ae" ).should be true

      TranslationIO.config.localization_key_prefixes = ['date.first_day_of_week_in_english']
      TranslationIO::YamlEntry.localization?('en.date.first_day_of_week_in_english', 'monday').should be true
    end
  end

  describe '#localization_prefix?' do
    it do
      TranslationIO::YamlEntry.localization_prefix?('en.date.formats.default').should be true
      TranslationIO::YamlEntry.localization_prefix?('en.date.order[0]'       ).should be true
      TranslationIO::YamlEntry.localization_prefix?('en.date.order[1]'       ).should be true
      TranslationIO::YamlEntry.localization_prefix?('en.date.order[2]'       ).should be true

      TranslationIO::YamlEntry.localization_prefix?('en.yo'                                       ).should be false
      TranslationIO::YamlEntry.localization_prefix?('en.number.human.decimal_units.units.thousand').should be false
    end
  end
end
