<template>
  <div>
    <div class="mb-4">Hướng dẫn cho iOS:</div>

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
          <p>Tải ứng dụng qua Appstore:</p>
          <div class="flex mb-4">
            <a href="https://apps.apple.com/us/app/1-1-1-1-faster-internet/id1423538627" target="_blank"
               class="bg-green-700 hover:bg-green-800 p-2 rounded transition no-underline block">
              Tải Cloudflare WARP
            </a>
          </div>
          <p>Nhấn vào nút Cài đặt và đợi trong giây lát.</p>
          <p><img src="@/assets/warp-ios/1.jpg" class="max-h-[75vh] mx-auto" alt=""></p>

          <p class="font-bold">Bước 2: Bật WARP</p>
          <p>Sau khi cài đặt xong, mở WARP lên và thực hiện chấp nhận các điều khoản.</p>
          <p><img src="@/assets/warp-ios/2.png" class="max-h-[75vh] mx-auto" alt=""></p>
          <p>Bạn cần cho phép WARP cài đặt một VPN Profile nếu là lần đầu sử dụng.</p>
          <p><img src="@/assets/warp-ios/3.png" class="max-h-[75vh] mx-auto" alt=""></p>
          <p>Sau đó nhấn vào nút công tắc để chuyển về trạng thái bật. Khi chương trình báo "Connected" thì tức là bạn đã kết nối WARP thành công.</p>
          <p><img src="@/assets/warp-ios/4.png" class="max-h-[75vh] mx-auto" alt=""></p>

          <p class="font-bold">Bước 3: Thử truy cập Cứu Truyện qua tên miền chính thức.</p>
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
</script>
