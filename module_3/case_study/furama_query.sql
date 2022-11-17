use furama;

-- 2.	Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” 
-- và có tối đa 15 kí tự.
-- TH1: họ bắt đầu là H,K,T
select *, char_length(ho_ten)
from nhan_vien as nv
where ho_ten like 'H%' or ho_ten like 'T%' or ho_ten like 'K%'
having char_length(ho_ten) <=15;

-- TH2: tên bắt đầu bằng H,T,K
select *, char_length(ho_ten)
from nhan_vien as nv
where substring_index(ho_ten," ",-1)  like 'H%' or substring_index(ho_ten," ",-1) like 'T%' or substring_index(ho_ten," ",-1) like 'K%'
having char_length(ho_ten) <=15;

-- 3.	Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi
-- và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
select * from khach_hang
where (dia_chi like "%Đà Nẵng%" or dia_chi like '%Quảng Trị%') 
and datediff(current_date,ngay_sinh)/365 between 18 and 50;

-- 4.	Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần.
-- Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của khách hàng.
-- Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond”.
select kh.*, count(kh.ma_khach_hang) as so_lan_dat_phong
from khach_hang as kh
inner join loai_khach as lk on lk.ma_loai_khach = kh.ma_loai_khach
inner join hop_dong as hd on hd.ma_khach_hang = kh.ma_khach_hang
where ten_loai_khach = "Diamond"
group by kh.ma_khach_hang
order by so_lan_dat_phong;

-- 5. Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien
-- (Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) cho tất cả các khách hàng đã từng đặt phòng.
-- (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).

select kh.ma_khach_hang, kh.ho_ten, lk.ten_loai_khach,hd.ma_hop_dong, dv.ten_dich_vu,hd.ngay_lam_hop_dong, hd.ngay_ket_thuc,sum(ifnull(dv.chi_phi_thue,0) + ifnull(dvdk.gia* hdct.so_luong,0))  as tong_tien
from hop_dong as hd
right join khach_hang as kh on kh.ma_khach_hang = hd.ma_khach_hang
left join loai_khach as lk on lk.ma_loai_khach = kh.ma_loai_khach
left join hop_dong_chi_tiet as hdct on hdct.ma_hop_dong= hd.ma_hop_dong
left join dich_vu as dv on dv.ma_dich_vu = hd.ma_dich_vu
left join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
group by hd.ma_hop_dong
;

-- select hd.ma_hop_dong,kh.ho_ten,hdct.ma_hop_dong_chi_tiet, dv.ten_dich_vu,dvdk.ten_dich_vu_di_kem, dv.chi_phi_thue+ dvdk.gia * hdct.so_luong as tong_tien
-- from hop_dong as hd
-- right join khach_hang as kh on kh.ma_khach_hang = hd.ma_khach_hang
-- left join hop_dong_chi_tiet as hdct on hdct.ma_hop_dong= hd.ma_hop_dong
-- left join dich_vu as dv on dv.ma_dich_vu = hd.ma_dich_vu
-- left join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
-- order by hd.ma_hop_dong;

-- 6.	Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu của 
-- tất cả các loại dịch vụ chưa từng được khách hàng thực hiện đặt từ quý 1 của năm 2021 (Quý 1 là tháng 1, 2, 3).

select distinct dv.ma_dich_vu, dv.ten_dich_vu, dv.dien_tich, dv.chi_phi_thue, ldv.ten_loai_dich_vu
from dich_vu as dv
left join hop_dong as hd on hd.ma_dich_vu = dv.ma_dich_vu
left join loai_dich_vu as ldv on ldv.ma_loai_dich_vu = dv.ma_loai_dich_vu
where month(hd.ngay_lam_hop_dong) not in (1,2,3);

-- 7.	Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu 
-- của tất cả các loại dịch vụ đã từng được khách hàng đặt phòng trong năm 2020
-- nhưng chưa từng được khách hàng đặt phòng trong năm 2021.

select distinct dv.ma_dich_vu,dv.ten_dich_vu, dv.dien_tich, dv.so_nguoi_toi_da, dv.chi_phi_thue, ten_loai_dich_vu 
from dich_vu as dv
inner join loai_dich_vu as ldv on ldv.ma_loai_dich_vu = dv.ma_loai_dich_vu
left join hop_dong as hd on hd.ma_dich_vu= dv.ma_dich_vu 
where year(hd.ngay_lam_hop_dong) =2020 and dv.ma_dich_vu not in (select distinct dv.ma_dich_vu
from dich_vu as dv
left join hop_dong as hd on hd.ma_dich_vu= dv.ma_dich_vu 
where year(hd.ngay_lam_hop_dong) = 2021) ;