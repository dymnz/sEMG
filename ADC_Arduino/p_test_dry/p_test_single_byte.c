/* https://stackoverflow.com/questions/6947413/how-to-open-read-and-write-from-serial-port-in-c */

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <math.h>

#include <sys/time.h>

#define packet_size 4
#define in_packet_num 6

#define return_channel 0

const int in_packet_len = packet_size * in_packet_num;
const int out_packet_len = packet_size * 1;

struct timeval last_time, current_time;

union float_packet {
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

	union float_packet temp_packet;
	union float_packet packet_array[in_packet_num];
	int byte_idx = 0;
	int packet_idx = 0;

	do {
		unsigned char temp_byte;
		int rdlen;

		if (byte_idx == 0 && packet_idx == 0)
			gettimeofday(&last_time, NULL);

		rdlen = read(fd, &temp_byte, 1);	// Read one byte
		if (rdlen > 0) {

			temp_packet.byte_array[byte_idx] = temp_byte;

			++byte_idx;

			if (byte_idx >= in_packet_len) {
				byte_idx = 0;

				packet_array[packet_idx] = temp_packet;

				++packet_idx;

				if (packet_idx >= in_packet_num) {
					packet_idx = 0;

					wlen = write(fd,
					             packet_array[return_channel].byte_array,
					             out_packet_len);
					
					gettimeofday(&current_time, NULL);

					double secs = (double)(current_time.tv_usec - last_time.tv_usec) / 1000000 + (double)(current_time.tv_sec - last_time.tv_sec);
					printf("took %lf\n", secs);
					//last_time = current_time;
					//printf("%f\n", packet_array[return_channel].float_value);
					if (wlen != out_packet_len) {
						printf("Error from write: %d, %d\n", wlen, errno);
						return 999;
					}
				}
			}



		} else if (rdlen < 0) {
			printf("Error from read: %d: %s\n", rdlen, strerror(errno));
		}
		/* repeat read to get full message */
	} while (1);


	return 0;
}