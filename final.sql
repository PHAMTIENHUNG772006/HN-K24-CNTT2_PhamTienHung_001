drop database final_exam;
create database final_exam;
use final_exam;


create table Shippers(
	shipper_id int primary key auto_increment,
    fullname varchar(100) not null,
    phone char(10) unique,
    type_license varchar(255) not null,
    start_shipper decimal(2,1) default (5.0)
);

create table Vehicle_Details(
	vehical_id char(3) primary key,
    shipper_id int,
    license_plate varchar(50) unique,
    type_vehical enum('Tải','Xe máy','Container'),
    payload int check(payload > 0),
    
    constraint fk_shipper_id foreign key (shipper_id) references shippers(shipper_id)
);


create table Shipments(
	order_id char(4) primary key,
    product_name varchar(255),
    weight decimal(10,1) check(weight > 0),
    product_price int,
    shipment_status enum('In Transit','Delivered','Returned')
);


create table Delivery_Orders(
	tikket_id char(4) primary key ,
    order_id char(4) ,
    shipper_id int,
    order_date datetime default current_timestamp,
    ship_cost int,
    order_status enum('Pending','Processing','Finished'),
    
     constraint fk_order_id foreign key (order_id) references Shipments(order_id),
	constraint fk_shipper_id_order foreign key (shipper_id) references shippers(shipper_id)
);

create table Delivery_Log(
	delivery_id int primary key auto_increment,
    tiket_id char(4),
    address varchar(255),
    delivery_date datetime ,
    note text,
    
    constraint fk_tiket_id foreign key (tiket_id) references Delivery_Orders(tikket_id)
);


insert into shippers (fullname,phone,type_license,start_shipper) values 

('Nguyen Van An','0901234567','C', 4.8),
('Tran Thi Binh','0912345678','A2', 5.0),
('Nguyen Van An','0983456789','FC', 4.2),
('Nguyen Van An','0354567890','B2', 4.9),
('Nguyen Van An','0775678901','C', 4.7);

-- kiểm tra dữ liệu thêm vào shippers
select * from shippers;


insert into Vehicle_Details (vehical_id,shipper_id,license_plate,type_vehical,payload) values 

('101',1,'29C-123.45', 'Tải',3500),
('102',2,'59A-888.88', 'Xe máy',500),
('103',3,'15R-999.99', 'Container',32000),
('104',4,'30F-111.22', 'Tải',1500),
('105',5,'43C-444.55', 'Tải',5000);

-- kiểm tra dữ liệu thêm vào Vehicle_Details
select * from Vehicle_Details;




insert into Shipments (order_id,product_name,weight,product_price,shipment_status) values 

('5001','Smart TV Samsung 55 inch',25.5, 15000000,'In Transit'),
('5002','Laptop Dell XPS',2.0, 35000000,'Delivered'),
('5003','Máy nén khí công nghiệp',450.0, 120000000,'In Transit'),
('5004','Thùng trái cây nhập khẩu',15.0, 2500000,'Returned'),
('5005','Máy giặt LG Inverter',70.0, 9500000,'In Transit');


-- kiểm tra dữ liệu thêm vào Shipments
select * from Shipments;



insert into Delivery_Orders (tikket_id,order_id,shipper_id,ship_cost,order_status) values 

('9001','5001',1, 2000000,'Processing'),
('9002','5002',2, 3500000,'Finished'),
('9003','5003',3, 2500000,'Processing'),
('9004','5004',4, 1500000,'Finished'),
('9005','5005',5, 2500000,'Pending');


-- kiểm tra dữ liệu thêm vào Shipments
select * from Delivery_Orders;



insert into Delivery_Log (tiket_id,address,delivery_date,note) values 

('9001','Kho tổng (Hà Nội)','2021-05-15 08:15:00','Rời kho'),
('9002','Trạm thu phí Phủ Lý','2021-05-17 10:00:00','Đang giao'),
('9003','Quận 1, TP.HCM','2024-05-19 10:30:00','Đã đến điểm đích'),
('9004','Cảng Hải Phòng','2024-05-20 11:00:00','Rời kho'),
('9005','Kho hoàn hàng (Đà Nẵng)','2024-05-21 14:00:00','Đã nhập kho trả hàng');


-- kiểm tra dữ liệu thêm vào Shipments
select * from Delivery_Log;


--   1. Viết câu lệnh tăng phí vận chuyển thêm 10% cho tất cả các phiếu điều phối có trạng thái 'Finished' và có trọng lượng hàng hóa lớn hơn 100kg.

update Shipments s
join Delivery_Orders de on de.order_id = s.order_id
set ship_cost = (ship_cost * 0.1)
where order_status = 'Finished' and weight > 100;


delete from Delivery_Log
where delivery_date < '17/05/2024';

-- PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN (15 ĐIỂM)

  -- Câu 1 (5đ): Liệt kê danh sách các phương tiện Biển số xe, Loại xe, Trọng tải tối đa có trọng tải trên 5.000kg hoặc thuộc loại xe 'Container' nhưng có trọng tải dưới 2.000kg.
  
select license_plate ,type_vehical, payload from Vehicle_Details
where (payload > 5000 and type_vehical = 'Container') or payload < 2000 ;
  
--  Câu 3 (5đ): Viết truy vấn để hiển thị danh sách các vận đơn ở trang thứ 2(giả sử mỗi trang có 2 đơn), với điều kiện danh sách gốc được sắp xếp giảm dần theo Giá trị hàng hóa..
  
select * from Shipments
order by product_price desc limit 2 offset 2;

  
-- PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO (20 ĐIỂM)
-- Câu 1 (6đ): Viết lệnh hiển thị thông tin đơn hàng gồm: Họ t
  
select s.fullname,de.order_id,sm.product_name, de.ship_cost, de.order_date from Delivery_Orders de
join shippers s on s.shipper_id = de.shipper_id
join Shipments sm on sm.order_id = de.order_id;
  
--  Câu 2 (7đ): Tính tổng Phí vận chuyển của mỗi tài xế. Chỉ lấy các tài xế có tổng Phí vận chuyển lớn hơn 3.000.000 VNĐ
  
select s.fullname, sum(de.ship_cost) as total_ship_cost from Delivery_Orders de
join shippers s on s.shipper_id = de.shipper_id
group by s.shipper_id
having total_ship_cost > 3000000
;

  
--   Câu 3 (7đ): Tìm thông tin những tài xế có trung bình Điểm đánh giá cao nhất.
  
select * from shippers 
where start_shipper = (select max(start_shipper) from shippers);

-- PHẦN 4: INDEX VÀ VIEW (10 ĐIỂM)
-- Câu 1 (5đ): Tạo một Composite Index tên idx_shipment_status_value trên bảng Shipments gồm hai cột: Trạng thái và Giá trị hàng hóa

create index idx_shipment_status_value on shipments(shipment_status,product_price);

-- Câu 2 (5đ): Tạo một View tên vw_driver_performance hiển thị: Họ tên tài xế, Tổng số chuyến hàng đã nhận và Tổng doanh thu phí vận chuyển (không tính các đơn bị 'Cancelled').

create view vw_driver_performance  
as
select s.fullname, count(s.shipper_id) as count_order,sum(de.ship_cost) as total_ship_cost  from shippers s
join Delivery_Orders de on de.shipper_id = s.shipper_id
group by s.shipper_id;
select * from vw_driver_performance;




-- PHẦN 5: TRIGGER (10 ĐIỂM)

delimiter //
create trigger trg_after_delivery_finish 
after update
on Delivery_Orders
for each row 

begin 
	insert into Delivery_Log (address,delivery_date,note)value ( 'Delivery Completed Successfully','Tại điểm đích',now());

end //

delimiter ;



-- Câu 2 (5đ): Viết Trigger trg_update_driver_rating. Mỗi khi một phiếu điều phối mới được thêm vào với trạng thái 'Finished', tự động cộng 0.1 điểm vào rating của tài xế đó (tối đa không quá 5.0).


drop trigger trg_update_driver_rating ;
delimiter //
create trigger trg_update_driver_rating 
after insert
on Delivery_Orders
for each row 
begin 
	

    if (select start_shipper from shippers where shipper_id = new.shipper_id) > 5.0 then
	update shippers 
    set start_shipper = start_shipper;
    end if;

	if (new.order_status = 'Finished') then 
    update shippers 
    set start_shipper = start_shipper + 0.1;
    end if;

end //

delimiter ;

-- PHẦN 6: STORED PROCEDURE (20 ĐIỂM)

--   - Câu 1 (10đ): Viết Procedure sp_check_payload_status nhận vào Mã phương tiện. Trả về tham số OUT message:
    -- 'Quá tải' nếu trọng tải thực tế của vận đơn > trọng tải tối đa của xe.
    -- 'Đầy tải' nếu trọng tải thực tế = trọng tải tối đa.
    -- 'An toàn' nếu trọng tải thực tế < trọng tải tối đa.

delimiter //
create procedure sp_check_payload_status (p_vehical_id char(3), out message varchar(255))
begin 
	declare mess_error varchar(255);
    declare cur_weith int;
    declare cur_vehical char(3);
    
    select weight into cur_weith from Shipments where vehical_id = p_vehical_id;
    select vehical_id into cur_vehical from vehicle_details where vehical_id = p_vehical_id;
    
	if (select payload from vehicle_details) > cur_weith then
    set message = 'Quá tải';
	end if;
    
    if (select payload from vehicle_details) = cur_weith then
    set message = 'Đầy tả';
	end if;
    
    if (select payload from vehicle_details) > cur_weith then
    set message = 'An toàn';
	end if;

end //

delimiter ;

set @result_message = '';
call sp_check_payload_status('101',@result_message);

select @result_message;

--   - Câu 2 (10đ): Viết Procedure sp_reassign_driver để đổi tài xế cho một đơn hàng:
    -- B1: Bắt đầu giao dịch.
    -- B2: Cập nhật mã tài xế mới trong bảng Delivery_Orders.
    -- B3: Ghi nhật ký vào Delivery_Log lý do 'Driver Reassigned'.
    -- B4: COMMIT nếu thành công, ROLLBACK nếu lỗi.
  
  delimiter //
create procedure sp_check_payload_status (p_vehical_id char(3), out message varchar(255))
begin 
	declare mess_error varchar(255);
    declare cur_weith int;
    declare cur_vehical char(3);
    
    select weight into cur_weith from Shipments where vehical_id = p_vehical_id;
    select vehical_id into cur_vehical from vehicle_details where vehical_id = p_vehical_id;
    
	if (select payload from vehicle_details) > cur_weith then
    set message = 'Quá tải';
	end if;
    
    if (select payload from vehicle_details) = cur_weith then
    set message = 'Đầy tả';
	end if;
    
    if (select payload from vehicle_details) > cur_weith then
    set message = 'An toàn';
	end if;

end //

delimiter ;

set @result_message = '';
call sp_check_payload_status('101',@result_message);

select @result_message;
  