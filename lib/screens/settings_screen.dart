import 'package:flutter/material.dart';
import 'firestore_service.dart';
import '/constants/app_colors.dart';  // นำเข้าไฟล์ AppColors

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _units = 'Celsius';
  String _language = 'English';
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    String userId = 'user123'; // แทนที่ด้วย ID ของผู้ใช้จริง
    Map<String, dynamic>? settings = await _firestoreService.getSettings(userId);
    if (settings != null) {
      setState(() {
        _units = settings['units'] ?? 'Celsius';
        _language = settings['language'] ?? 'English';
        _notificationsEnabled = settings['notificationsEnabled'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,  // ใส่สี background จาก AppColors
      appBar: AppBar(
        backgroundColor: AppColors.accentBlue,  // สีของ AppBar
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.white),  // เพิ่มสีข้อความเป็นสีขาว
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // เพิ่มการจัดตำแหน่งให้ชิดซ้าย
          children: [
            const Text(
              'Units',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,  // ใช้สีขาวจาก AppColors
              ),
            ),
            DropdownButton<String>(
              isExpanded: true,
              alignment: AlignmentDirectional.centerStart,  // ทำให้ dropdown icon ชิดซ้าย
              value: _units,
              dropdownColor: AppColors.accentBlue,  // สีพื้นหลัง dropdown
              onChanged: (value) {
                setState(() {
                  _units = value!;
                });
              },
              items: ['Celsius', 'Fahrenheit']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: AppColors.white),  // สีข้อความใน dropdown
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),  // เพิ่มช่องว่างระหว่าง dropdowns
            const Text(
              'Language',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,  // ใช้สีขาวจาก AppColors
              ),
            ),
            DropdownButton<String>(
              isExpanded: true,
              alignment: AlignmentDirectional.centerStart,  // ทำให้ dropdown icon ชิดซ้าย
              value: _language,
              dropdownColor: AppColors.accentBlue,  // สีพื้นหลัง dropdown
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
              },
              items: ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese', 'Thai']  // เพิ่มภาษาอื่นๆ ได้ที่นี่
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: AppColors.white),  // สีข้อความใน dropdown
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),  // เพิ่มช่องว่างระหว่าง dropdowns
            SwitchListTile(
              title: const Text(
                'Enable Notifications',
                style: TextStyle(color: AppColors.white),  // สีข้อความของ Switch
              ),
              activeColor: AppColors.lightBlue,  // สีเมื่อ Switch เปิด
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBlue,  // สีพื้นหลังปุ่ม
                foregroundColor: AppColors.white,  // สีของข้อความในปุ่ม
                disabledBackgroundColor: AppColors.grey,  // สีเมื่อปุ่มถูกปิดใช้งาน
                disabledForegroundColor: Colors.white70,  // สีของข้อความเมื่อปุ่มถูกปิดใช้งาน
              ),
              onPressed: () async {
                String userId = 'username01'; // แทนที่ด้วย ID ของผู้ใช้จริง
                await _firestoreService.updateSettings(
                  userId,
                  _units,
                  _language,
                  _notificationsEnabled,
                );
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
