# ��� ��������� ������

1. ��������� `docker build -t cpp-ab-tester .` � ���������� docker
1. ����� ��������� r.bat/r.sh � ������������ ���������� ��������� ������, ������ ok, ce ��� partial
1. ���������� � outcome/result.json

# ���������� � ����������

�����-��������� ����� ����������� ��� ���:

`docker run --rm -v $(pwd)/income:/income -v $(pwd)/outcome:/outcome <container-name>`

� `/income` �� ������� �� ��, ��� ������ �������� � ����������������� ����.

� `/outcome` �� ������ �������� ������������ ���� result.json. � ���� ������ ��� ����: 

1. verdict=COMPILATION_ERROR|OK,
1. points=������������ �����\ ���������� ������� �������, �� ����������� 10000, �� ����� 3 ������ ����� ���������� �����,
1. comment=���������������� ����������� (��������), ������� ����� �������� ���������

### �������� ��������� ����������:

1. ���� ���� ���� ���������� ����������� �������, �� ����������� ������� ���. ���� �� ����������, �� ������� ����� result.json:
`{"verdict":"COMPILATION_ERROR","points":0,"comment":"/income/program.cpp: In function 'int main()':\n/income/program.cpp:9:13: error: expected ';' before '}' token\n    9 |     return 0\n      |             ^\n      |             ;\n   10 | }\n      | ~            "}`

1. ���� ���� ���������� ���, �� ������� � ������������ �� ������������������ ������ (�������� �� test cases).

1. ��������� �� ������ �� ���, ����� ��������, �������, ��� �� ����� �������� ���������.

1. ����������� ��� � ����� �������� result.json:
`{"verdict":"OK","points":3,"comment":"Test case 1: Passed\nTest case 2: Passed\nTest case 3: Passed\n"}`

1. �� ������� Codeforces ����������� � ����� �������/������ ����� ������ �� ���� ������ ����������, ������� ���� ����� ��������� ����������� �� ���� �����,
�� ������������ �� ���-�� ������ ����������

�������� comment �� ������ ������� 1KB � ����� ������ ��� ����� ������


