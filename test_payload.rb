# This is a test payload file
puts "PAYLOAD_EXECUTED: If you see this, test code ran"
File.write("/tmp/payload_test.txt", "PAYLOAD_EXECUTED")