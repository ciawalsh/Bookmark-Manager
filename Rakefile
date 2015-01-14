require 'data_mapper'
require './database'

task :auto_upgrade do
	
	DataMapper.auto_upgrade!

	puts "Auto-upgrade complete (no data loss)"

end

task :auto_migrate do

	DataMapper.auto_migrate! # USE WITH CAUTION... In fact try not to use this unless its completely neccessary!

	puts "Auto-migrate complete (data was lost)"

end
