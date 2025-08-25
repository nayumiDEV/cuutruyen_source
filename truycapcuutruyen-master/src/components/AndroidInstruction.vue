<template>
  <div>
    <div class="mb-4">Hướng dẫn cho Android:</div>

    <div class="collapsible">
      <button class="collapsible-title" @click="isExpandWarp = !isExpandWarp">Cách 1: Sử dụng Cloudflare WARP</button>

      <Collapse :when="isExpandWarp">
        <div class="collapsible-content prose prose-invert prose-gray">
          <p><strong>Cloudflare WARP</strong> là một dịch vụ VPN hoàn toàn miễn phí, cách sử dụng đơn giản và không cần đăng ký tài khoản.
            Sử dụng WARP có thể giúp bỏ chặn tất cả các trang web bị chặn bởi nhà mạng của Việt Nam,
            cũng như các trang web bị chặn khi sử dụng mạng ở công ty, doanh nghiệp.
            Tuy là một dịch vụ VPN, nhưng WARP có tốc độ trung bình cao do được chống lưng bởi ông lớn Cloudflare.</p>
          <p class="">
            Dễ sử dụng: <span class="text-green-500">dễ</span><br>
            Tốc độ: <span class="text-green-500">nhanh</span><br>
            Chi phí: <span class="text-green-500">miễn phí</span>
          </p>
          <p class="font-bold">Bước 1: Cài đặt WARP</p>
          <p>Tải ứng dụng qua Cửa Hàng Play:</p>
          <div class="flex mb-4">
            <a href="https://play.google.com/store/apps/details?id=com.cloudflare.onedotonedotonedotone" target="_blank"
               class="bg-green-700 hover:bg-green-800 p-2 rounded transition no-underline block">
              Tải Cloudflare WARP
            </a>
          </div>
          <p>Nhấn vào nút Cài đặt và đợi trong giây lát.</p>
          <p><img src="@/assets/warp-android/1.jpg" class="max-h-[75vh] mx-auto" alt=""></p>

          <p class="font-bold">Bước 2: Bật WARP</p>
          <p>Sau khi cài đặt xong, mở WARP lên và thực hiện chấp nhận các điều khoản.</p>
          <p><img src="@/assets/warp-android/2.jpg" class="max-h-[75vh] mx-auto" alt=""></p>
          <p>Bạn cần cho phép WARP cài đặt một VPN Profile nếu là lần đầu sử dụng.</p>
          <p><img src="@/assets/warp-android/3.jpg" class="max-h-[75vh] mx-auto" alt=""></p>
          <p>Sau đó nhấn vào nút công tắc để chuyển về trạng thái bật. Khi chương trình báo "Connected" thì tức là bạn đã kết nối WARP thành công.</p>
          <p><img src="@/assets/warp-android/4.jpg" class="max-h-[75vh] mx-auto" alt=""></p>

          <p class="font-bold">Bước 3: Thử truy cập cứu truyện qua tên miền chính thức.</p>
          <p>Vẫn không truy cập được? Thử tham gia vào group <a href="https://www.facebook.com/groups/cuutruyen2vn" target="_blank">Mặt tối của Cứu Truyện</a>,
            hoặc nhắn tin cho <a href="https://facebook.com/cuutruyentranh" target="_blank">fanpage Cứu Truyện</a> để tìm sự trợ giúp!</p>
        </div>
      </Collapse>
    </div>

    <div class="collapsible">
      <button class="collapsible-title" @click="isExpandPowerTunnel = !isExpandPowerTunnel">Cách 2: Sử dụng PowerTunnel</button>
      <Collapse :when="isExpandPowerTunnel">
        <div class="collapsible-content prose prose-invert prose-gray">
          <p><strong>PowerTunnel</strong> là phần mềm mã nguồn mở giúp thiết đặt DNS bảo mật và chống lại việc kiểm duyệt internet thông qua DPI (Deep Packet Inspection).
            <strong>PowerTunnel không phải là dịch vụ VPN</strong>, nó chỉ thiết lập một proxy cục bộ để xử lý lưu lượng truy cập,
            không hề gửi lưu lượng cho bên thứ 3. Vì vậy, PowerTunnel cho tốc độ vào mạng rất nhanh (so với các dịch vụ VPN), đảm bảo quyền riêng tư và tiết kiệm pin hơn.</p>
          <p class="">
            Dễ sử dụng: <span class="text-yellow-500">trung bình</span><br>
            Tốc độ: <span class="text-green-500">rất nhanh</span><br>
            Chi phí: <span class="text-green-500">miễn phí</span>
          </p>
          <p class="font-bold">Bước 1: Cài đặt PowerTunnel</p>
          <p>Tải PowerTunnel.apk qua trang GitHub Release của tác giả:</p>
          <div class="flex mb-4">
            <a href="https://github.com/krlvm/PowerTunnel-Android/releases" target="_blank"
               class="bg-green-700 hover:bg-green-800 p-2 rounded transition no-underline block">
              Tải PowerTunnel
            </a>
          </div>
          <p>Tải về và cài đặt tập tin PowerTunnel.apk kể trên và đợi trong giây lát.</p>
          <p><img src="@/assets/powertunnel-android/1.jpg" class="max-h-[75vh] mx-auto" alt=""></p>

          <p>Trong quá trình cài đặt, có thể bạn cần cho phép trình duyệt của bạn cài đặt ứng dụng không rõ nguồn.</p>
          <p><img src="@/assets/powertunnel-android/2.jpg" class="max-h-[75vh] mx-auto" alt=""></p>

          <p class="font-bold">Bước 2: Bật PowerTunnel</p>
          <p>Sau khi cài đặt xong, mở ứng dụng PowerTunnel, thực hiện cài đặt VPN profile và nhấn vào nút Connect.</p>
          <p><img src="@/assets/powertunnel-android/3.jpg" class="max-h-[75vh] mx-auto" alt=""></p>
          <p>Khi biểu tượng của PowerTunnel chuyển sang màu xanh lá thì tức là PowerTunnel đã được kích hoạt thành công.</p>

          <p class="font-bold">Bước 3: Thử truy cập cứu truyện qua tên miền chính thức.</p>
          <p>Vẫn không truy cập được? Thử tham gia vào group <a href="https://www.facebook.com/groups/cuutruyen2vn" target="_blank">Mặt tối của Cứu Truyện</a>,
            hoặc nhắn tin cho <a href="https://facebook.com/cuutruyentranh" target="_blank">fanpage Cứu Truyện</a> để tìm sự trợ giúp!</p>
        </div>
      </Collapse>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Collapse } from 'vue-collapsed'

const isExpandWarp = ref(false)
const isExpandPowerTunnel = ref(false)
</script>
