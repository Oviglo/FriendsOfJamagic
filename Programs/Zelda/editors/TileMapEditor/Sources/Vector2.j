// Vector 2 Object

function Vector2(x, y)
{
	// Properties
	this.x = x;
	this.y = y;
	
	// Constants
	this.UP = new Vector2(0, -1);
	this.DOWN = new Vector2(0, 1);
	this.RIGHT = new Vector2(1, 0);
	this.LEFT = new Vector2(-1, 0);
	this.ZERO = new Vector2(0, 0);
	
	// Methods
	this.length = Vector2_length;
	this.normalize = Vector2_normalize;
	this.isEqual = Vector2_isEqual;
}

function Vector2_length()
{
	return Math.Sqrt(Math.Pow(this.x, 2.0) + Math.Pow(this.y, 2.0));
}

function Vector2_normalize(value)
{
	var lgth = this.length();
	if (lgth == 0)
		return;
		
	this.x = this.x/lgth * value;
	this.y = this.y/lgth * value;
}

function Vector2_isEqual(vec)
{
	if (!Program.IsObject(vec, "Vector2"))
		return false;
	
	return this.x == vec.x && this.y == vec.y;
}