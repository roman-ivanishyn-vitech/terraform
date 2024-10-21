resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "main_instance" {
  ami           = "ami-066784287e358dad1"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.main_instance_sg.id]
  tags = {
    Name = "main_instance"
    Env  = var.environment
  }
}
