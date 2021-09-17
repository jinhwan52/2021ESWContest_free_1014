/* =====================================================================
function: fix ()
purpose	: Round down a number
argument:
	double_number: the number you want to round down
return	:
	fixed_number: the return after roundign down
!!Caution
	Input number (double_number) must be positive number
===================================================================== */
void fix(double double_number, double *integer_part, double *fraction_part) {
	int temp_double_number;	// the size of "int" is 4 bit 
	temp_double_number = double_number * 10;
	*integer_part = temp_double_number / 10;

	if (*integer_part >= 0) {
		*fraction_part = double_number - *integer_part;
	}
	else {
		printf("ERROR: Input number %lf is negative!!!\n", double_number);
	}
	//printf("double number is %lf, integer part is %lf, fraction part is %lf \n", double_number, *integer_part, *fraction_part);

}
/* =====================================================================
function: pow ()
purpose	: x to the power of y
argument:
	x: base
	y: exponent
return	:
	power_number: x^y
!!Caution
	y must positive or zero.
===================================================================== */
double jh_pow(double x, int y) {
	double power_number = x;
	int itr;
	if (y == 0) {
		power_number = 1;
	}
	else if (y == 1) {
		power_number = x;
	}
	else {
		for (itr = 0; itr < y-1; itr++) {
			power_number = power_number * x ;
		}
	}
	
	return power_number;
}
/* =====================================================================
function: jh_abs ()
purpose	: Absolute of x
argument:
	x: input number
return	:
	power_number: |x|
!!Caution
===================================================================== */
double jh_abs(double x) {
	double absolute_number;
	if (x > 0) {
		absolute_number = x;
	}
	else {
		absolute_number = -1 * x;
	}
	return absolute_number;
}
/* =====================================================================
function: double2ieee ()
purpose	: Change a double number to a modified IEEE number (sign 1/expoent 8/fraction 11) 
argument:
	double_number: the number you want to change	
return	:
	changed_number: the changed modified IEEE number
!!Caution
===================================================================== */
char* double2ieee(double double_number) {
	////////////////////////////////////////////////////////////
		// Step 1. Find binary values of integer and fraction part
		// Finde sign bit, exponent bits, and fraction bits
	double ieee_number = double_number;
	double integer_part, fraction_part;
	int sign_bit = 0;
	if (ieee_number < 0) {
		sign_bit = 1;
		ieee_number = -1 * ieee_number;
	}
	fix(ieee_number, &integer_part, &fraction_part);

	// integer part change to the binary
	char temp_integer_bits[129];
	*temp_integer_bits = -1;
	double temp_integer_part = integer_part;
	double temp_quotient, temp_remainder;
	int itr_integer = 0;
	while (temp_integer_part != 0) {
		if ((int)temp_integer_part % 2 == 0) {
			if (*temp_integer_bits == -1) {
				*temp_integer_bits = 0;
			}
			else {
				*(temp_integer_bits + itr_integer) = 0;
			}
		}
		else {
			if (*temp_integer_bits == -1) {
				*temp_integer_bits = 1;
			}
			else {
				*(temp_integer_bits + itr_integer) = 1;
			}
		}
		itr_integer = itr_integer + 1;
		fix(temp_integer_part / 2, &temp_integer_part, &temp_remainder);
	}
	char integer_bits[itr_integer];
	int itr;
	int itr2 = 0;
	while (itr2 < itr_integer) {
		*(integer_bits + itr2) = *(temp_integer_bits + itr_integer - 1 - itr2);
		itr2 = itr2 + 1;
	}

	// Fraction part change to the binary
	char fraction_bits[22]; // find 11 more data-- > that will be used when normalization
	double temp_fraction_part = fraction_part;
	for (itr = 0; itr < 22; itr++) {
		fix(temp_fraction_part * 2, &temp_quotient, &temp_remainder);
		if (temp_quotient == 0) {
			*(fraction_bits + itr) = 0;
			temp_fraction_part = temp_fraction_part * 2;
		}
		else {
			*(fraction_bits + itr) = 1;
			temp_fraction_part = temp_fraction_part * 2 - 1;
		}
	}

	/////////////////////////////////////////////////////////////////
	// Step 2. Check conditions of integer and fraction to normalize
	// Does it shift left? (++exponent)
	int shift;
	double exponent;
	if (itr_integer == 0) {
		shift = 0;
	}
	else {
		shift = itr_integer - 1;
	}
	exponent = shift + 127;

	// Do shift it right (--exponent)
	char temp_normalized_fraction_bits[itr_integer + 22];
	int itr_norm = 0;
	while (itr_norm < itr_integer) {
		*(temp_normalized_fraction_bits + itr_norm) = *(integer_bits + itr_norm);
		itr_norm = itr_norm + 1;
	}
	int itr_norm2 = 0;
	while (itr_norm < itr_integer + 22) {
		*(temp_normalized_fraction_bits + itr_norm) = *(fraction_bits + itr_norm2);
		itr_norm = itr_norm + 1;
		itr_norm2 = itr_norm2 + 1;
	}
	int first_one_id = 1;
	itr_norm = 0;
	while (itr_norm < itr_integer + 22) {
		if (*(temp_normalized_fraction_bits + itr_norm) == 1) {
			break;
		}
		else {
			first_one_id = first_one_id + 1;
		}
		itr_norm = itr_norm + 1;
	}
	char normalized_faction_bits[11];
	itr_norm = 0;
	while (itr_norm < 11) {
		*(normalized_faction_bits + itr_norm) = *(temp_normalized_fraction_bits + first_one_id + itr_norm);
		itr_norm = itr_norm + 1;
	}

	if (shift == 0) {
		if (first_one_id == 23) {
			exponent = 0;
			//printf("the number is 0 \n");
		}
		else if (first_one_id == 1) {
			exponent = 127;
		}
		else {
			exponent = 127 - first_one_id;
		}
	}

	char exponent_bits[8];
	double temp_exponent_part = exponent;
	int itr_exp;
	for (itr_exp = 7; itr_exp > -1; itr_exp--) {
		fix(temp_exponent_part / 2, &temp_quotient, &temp_remainder);
		if (temp_remainder == 0) {
			*(exponent_bits + itr_exp) = 0;
		}
		else {
			*(exponent_bits + itr_exp) = 1;
		}
		temp_exponent_part = temp_quotient;
	}

	static char modified_IEEE[20];
	int itr_IEEE;
	itr_exp = 0;
	itr = 0;
	if (exponent == 0) {
		for (itr_IEEE = 0; itr_IEEE < 20; itr_IEEE++) *(modified_IEEE + itr_IEEE) = 0;
	}
	else {
		*modified_IEEE = sign_bit;
		for (itr_IEEE = 1; itr_IEEE < 9; itr_IEEE++) {
			*(modified_IEEE + itr_IEEE) = *(exponent_bits + itr_exp);
			itr_exp = itr_exp + 1;
		}
		for (itr_IEEE = 9; itr_IEEE < 20; itr_IEEE++) {
			*(modified_IEEE + itr_IEEE) = *(normalized_faction_bits + itr);
			itr = itr + 1;
		}
	}

	return modified_IEEE;
}

/* =====================================================================
function: ieee2double ()
purpose	: Change a modified IEEE number (sign 1/expoent 8/fraction 11) to a double number.
argument:
	IEEE_number: the number you want to change
return	:
	changed_number: the changed double number
!!Caution
===================================================================== */
double ieee2double(char* modified_IEEE){
	char sign_bit = *modified_IEEE;
	char exponent_bits[8];
	char fraction_bits[11];
	int itr;
	for (itr = 0; itr < 8; itr++) {
		*(exponent_bits + itr) = *(modified_IEEE + (1 + itr));
		*(fraction_bits + itr) = *(modified_IEEE + (9 + itr));

	}
	*(fraction_bits + 8) = *(modified_IEEE + 17);
	*(fraction_bits + 9) = *(modified_IEEE + 18);
	*(fraction_bits + 10) = *(modified_IEEE + 19);

	double exponent = 0;
	double fraction = 0;
	double double_number;
	for (itr = 0; itr < 8; itr++) {
		exponent = exponent + (double)*(exponent_bits + itr) * jh_pow(2, 7 - itr);
	}
	for (itr = 0; itr < 11; itr++) {
		fraction = fraction + (double)*(fraction_bits + itr) * jh_pow(0.5, itr + 1);
	}
	double_number = jh_pow(-1, sign_bit) * (1 + fraction) * jh_pow(2, exponent - 127); 
	return double_number;
}