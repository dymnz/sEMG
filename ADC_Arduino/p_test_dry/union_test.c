#include <stdio.h>

union float_packet{
	float float_value;
	char byte_array[4];
};

int main(int argc, char const *argv[])
{
	union float_packet packet_array[10];

	packet_array[0].float_value = 10;
	packet_array[1] = packet_array[0];

	printf("pa[0] = %f\n", packet_array[0].float_value);
	printf("pa[1] = %f\n", packet_array[1].float_value);

	packet_array[0].float_value = 11;
	printf("pa[0] = %f\n", packet_array[0].float_value);
	printf("pa[1] = %f\n", packet_array[1].float_value);	


	return 0;
}