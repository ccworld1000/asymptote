layout(local_size_x=LOCAL_SIZE_X) in;

uniform uint elements;

layout(binding=1, std430) buffer countBuffer
{
  uint count[];
};

layout(binding=2, std430) buffer localSumBuffer
{
  uint localSum[];
};

void main(void)
{
  uint id=gl_GlobalInvocationID.x;

  uint m=elements/(gl_WorkGroupSize.x*gl_NumWorkGroups.x);
  uint r=elements-m*gl_WorkGroupSize.x*gl_NumWorkGroups.x;
  uint row,stop;
  if(id < r) {
    row=m*id+id;
    stop=row+m+1u;
  } else {
    row=m*id+r;
    stop=row+m;
  }

  uint Sum=count[row];
  for(uint i=row+1u; i < stop; ++i)
    Sum += count[i];

  localSum[id+1u]=Sum;
}
