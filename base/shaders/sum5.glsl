layout(local_size_x=LOCAL_SIZE_X) in;

uniform uint offset2;

layout(binding=2, std430) buffer localSumBuffer
{
  uint localSum[];
};

void main(void)
{
  uint id=gl_GlobalInvocationID.x;
  uint Sum=localSum[offset2+id];

  uint row=LOCAL_SIZE_X*id+1u;
  uint stop=row+LOCAL_SIZE_X;

  for(uint i=row; i < stop; ++i) {
    Sum += localSum[i];
    localSum[i]=Sum;
  }
}
