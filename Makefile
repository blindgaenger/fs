test:
	@echo "Dir.glob('./spec/**/*_spec.rb').each { |file| require file}" | bundle exec ruby -rminitest/pride
