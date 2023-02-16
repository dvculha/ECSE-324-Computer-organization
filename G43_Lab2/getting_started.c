int main2(void)
{
   int a[5] = {1, 20, 3, 4, 5};
    int max_val;
    max_val = a[0];
    int n = sizeof(a)/sizeof(a[0]);
	int i = 0;
	for (i = 0; i < n; i++){
        if (max_val < a[i]){
            max_val = a[i];
        }
	}
    return max_val;
}
