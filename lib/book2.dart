import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'models/category.dart';
import 'models/expense.dart';


class Book2 extends StatefulWidget {
  final double amount;

  const Book2({
    super.key,
    required this.amount,
  });

  @override
  State<Book2> createState() => _Book2State();
}

class _Book2State extends State<Book2> {
  Category? _selectedCategory;
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  final _contentController = TextEditingController();
  final _recordController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  String _recordText = '20xx-xx-xx의 기록';

  @override
  void dispose() {
    _contentController.dispose();
    _recordController.dispose();
    _additionalInfoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    String formattedTime = _selectedTime != null
        ? _selectedTime!.format(context)
        : formattedDateTime.split(' ')[1];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('가계부'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  _editRecord();
                },
                child: Row(
                  children: [
                    Text(
                      _recordText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Text(
                    formattedDate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    formattedTime,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('카테고리', textAlign: TextAlign.left),
                    const SizedBox(width: 3.0),
                    _buildIconButton(Icons.hotel, '숙소', Category.sleep),
                    const SizedBox(width: 3.0),
                    _buildIconButton(
                        Icons.directions_car, '교통', Category.transport),
                    const SizedBox(width: 3.0),
                    _buildIconButton(Icons.restaurant, '식사', Category.food),
                    const SizedBox(width: 3.0),
                    _buildIconButton(
                        Icons.shopping_cart, '쇼핑', Category.shopping),
                    const SizedBox(width: 3.0),
                    _buildIconButton(Icons.category, '기타', Category.etc),
                    const SizedBox(width: 3.0),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          iconSize: 30.0,
                        ),
                        const Text('편집'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              Row(
                children: [
                  const Text('내용', textAlign: TextAlign.left),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '내용을 입력하세요',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              const Row(
                children: [
                  Text(
                    '메모',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  SizedBox(height: 40.0),
                  Text(
                    '멤버들과 추가로 공유하고 싶은 내용을 작성해 보세요!',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _additionalInfoController,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '내용',
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showImagePickerDialog(context);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      // 가계부 데이터 생성 후 저장
                      _addExpense();
                      // 홈 화면으로 이동
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('등록하기'),
                  ),
                ),
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }

  void _addExpense() {
    final expense = Expense(
      amount: widget.amount,
      category: _selectedCategory ?? Category.etc,
      content: _contentController.text,
      memo: _additionalInfoController.text,
      date: _selectedDate ?? DateTime.now(),
    );

    expenses.add(expense);
  }

  Widget _buildIconButton(IconData icon, String label, Category category) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          icon: Icon(icon, size: _selectedCategory == category ? 30 : 15),
          iconSize: 32.0,
        ),
        Text(label),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });

      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

//클릭하면 20xx-xx-xx의 기록 제목변경
  void _editRecord() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: _recordController,
            decoration: InputDecoration(hintText: '내용입력'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _recordText = _recordController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }
  
  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('사진/동영상 선택'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('갤러리에서 선택'),
                  onTap: () {
                    // 선택된 이미지를 처리하거나 저장하는 로직을 추가
                  },
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  child: const Text('카메라로 촬영'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
