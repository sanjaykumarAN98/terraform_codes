resource "aws_instance" "wordpress"{
  #for_each      = aws_subnet.public
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.elb.id]
  subnet_id = aws_subnet.public_subnet.id


  tags = {
      Name = "wordpress"
  }

  user_data = <<EOF
         #! /bin/bash
             sudo yum install httpd php php-mysql -y -q
             sudo cd /var/www/html
             echo "Welcome" > hi.html
             sudo wget https://wordpress.org/wordpress-5.1.1.tar.gz
             sudo tar -xzf wordpress-5.1.1.tar.gz
             sudo cp -r wordpress/* /var/www/html/
             sudo rm -rf wordpress
             sudo rm -rf wordpress-5.1.1.tar.gz
             sudo chmod -R 755 wp-content
             sudo chown -R apache:apache wp-content
             sudo wget https://s3.amazonaws.com/bucketforwordpresslab-donotdelete/htaccess.txt
             sudo mv htaccess.txt .htaccess
             sudo systemctl start httpd
             sudo systemctl enable httpd
      EOF

}
