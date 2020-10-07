shader_type canvas_item;

uniform bool active = false;

void fragment(){
	vec4 prevColor = texture(TEXTURE,UV);
	if(active){
		COLOR = vec4(1,1,1,prevColor.a);
	}else{
		COLOR = prevColor
	}
}