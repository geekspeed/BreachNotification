require 'rubygems'
require 'mechanize'
require 'digest'
require 'mysql'


begin
	con = Mysql.new 'SERVER', 'user', 'pass', 'DB'
	sql = "SELECT company,report_doc FROM 0_BREACH_NOTIFY_WA"
	rs = con.query(sql)
	n_rows = rs.num_rows
	c = ""
	d = ""
	e = ""
	if(n_rows != 0) 
		agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
		agent.pluggable_parser.default = Mechanize::Download
		rs.each_hash do |row|
			c = row["company"].gsub("/","").gsub(' ',"_").gsub(',',"").gsub(".","") + ".pdf"
			d = row["report_doc"]
			puts "[INFO] Grabbing #{d} to #{c}"
			begin
				agent.get(d).save(c)
			rescue Mechanize::Error => e
				puts "[ERROR] Problem."
			end
		end
	end

rescue Mysql::Error => e
	puts e.errno
	puts e.error

ensure
	con.close if con
end

