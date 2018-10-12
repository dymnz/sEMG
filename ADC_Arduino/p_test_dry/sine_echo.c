/* https://stackoverflow.com/questions/6947413/how-to-open-read-and-write-from-serial-port-in-c */

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#include <math.h>


#define DISPLAY_STRING
union float_packet{
		float float_value;
		char byte_array[4];
};

int set_interface_attribs(int fd, int speed)
{
	struct termios tty;

	if (tcgetattr(fd, &tty) < 0) {
		printf("Error from tcgetattr: %s\n", strerror(errno));
		return -1;
	}

	cfsetospeed(&tty, (speed_t)speed);
	cfsetispeed(&tty, (speed_t)speed);

	tty.c_cflag |= (CLOCAL | CREAD);    /* ignore modem controls */
	tty.c_cflag &= ~CSIZE;
	tty.c_cflag |= CS8;         /* 8-bit characters */
	tty.c_cflag &= ~PARENB;     /* no parity bit */
	tty.c_cflag &= ~CSTOPB;     /* only need 1 stop bit */
	tty.c_cflag &= ~CRTSCTS;    /* no hardware flowcontrol */

	/* setup for non-canonical mode */
	tty.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
	tty.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
	tty.c_oflag &= ~OPOST;

	/* fetch bytes as they become available */
	tty.c_cc[VMIN] = 1;
	tty.c_cc[VTIME] = 1;

	if (tcsetattr(fd, TCSANOW, &tty) != 0) {
		printf("Error from tcsetattr: %s\n", strerror(errno));
		return -1;
	}
	return 0;
}

void set_mincount(int fd, int mcount)
{
	struct termios tty;

	if (tcgetattr(fd, &tty) < 0) {
		printf("Error tcgetattr: %s\n", strerror(errno));
		return;
	}

	tty.c_cc[VMIN] = mcount ? 1 : 0;
	tty.c_cc[VTIME] = 5;        /* half second timer */

	if (tcsetattr(fd, TCSANOW, &tty) < 0)
		printf("Error tcsetattr: %s\n", strerror(errno));
}

int main(int argc, char const *argv[])
{
	char const *portname = argv[1];

	int fd;
	int wlen;

	fd = open(portname, O_RDWR | O_NOCTTY | O_SYNC);
	if (fd < 0) {
		printf("Error opening %s: %s\n", portname, strerror(errno));
		return -1;
	}
	/*baudrate 230400, 8 bits, no parity, 1 stop bit */
	set_interface_attribs(fd, B230400);
	//set_mincount(fd, 0);                /* set to pure timed read */

	float value = 0;
	union float_packet temp_packet;
	int packet_idx = 0;
	const int packet_size = 4;
	const int packet_num = 1;
	const int in_packet_len = packet_size * packet_num;
	const int out_packet_len = packet_size * 1;

	do {
		unsigned char temp_byte;
		int rdlen;

		rdlen = read(fd, &temp_byte, 1);	// Read one byte
		if (rdlen > 0) {

			temp_packet.byte_array[packet_idx] = temp_byte;

			++packet_idx;

			if (packet_idx >= in_packet_len) {
				value = temp_packet.float_value;

				union float_packet sin_value;
				sin_value.float_value = sin((double)value);

				printf("%f\n", sin_value.float_value);

				wlen = write(fd, sin_value.byte_array, out_packet_len);
				if (wlen != out_packet_len) {
					printf("Error from write: %d, %d\n", wlen, errno);
					return 999;
				}

				packet_idx = 0;
			}



		} else if (rdlen < 0) {
			printf("Error from read: %d: %s\n", rdlen, strerror(errno));
		}
		/* repeat read to get full message */
	} while (1);


	return 0;
}