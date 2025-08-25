<template>
  <div>
    <div class="mb-4">Hướng dẫn cho Windows:</div>

    <div class="collapsible">
      <button class="collapsible-title" @click="isExpandWarp = !isExpandWarp">Cách 1: Sử dụng Cloudflare WARP</button>

      <Collapse :when="isExpandWarp">
        <div class="collapsible-content prose prose-invert prose-gray">
          <p><strong>Cloudflare WARP</strong> là một dịch vụ VPN hoàn toàn miễn phí, cách sử dụng đơn giản và không cần đăng ký tài khoản.
            Sử dụng WARP có thể giúp bỏ chặn tất cả các trang web bị chặn bởi nhà mạng của Việt Nam,
            cũng như các trang web bị chặn khi sử dụng mạng ở công ty, doanh nghiệp.
            Tuy là một dịch vụ VPN, nhưng WARP có tốc độ trung bình cao do được chống lưng bởi ông lớn Cloudflare.</p>
          <p class="">
            Dễ sử dụng: <span class="text-green-500">đơn giản</span><br>
            Tốc độ: <span class="text-green-500">nhanh</span><br>
            Chi phí: <span class="text-green-500">miễn phí</span>
          </p>
          <p class="font-bold">Bước 1: Cài đặt WARP</p>
          <p>Tải phần mềm qua đường link dưới đây.</p>
          <div class="flex mb-4">
            <a href="https://1111-releases.cloudflareclient.com/windows/Cloudflare_WARP_Release-x64.msi" target="_blank"
               class="bg-green-700 hover:bg-green-800 p-2 rounded transition no-underline block">
              Tải Cloudflare WARP
            </a>
          </div>
          <p>Sau đó bạn cần chạy tập tin <strong>Cloudflare_WARP_Release-x64.msi</strong>, nhấn vào nút Next, sau đó nhấn Install để cài đặt.</p>
          <p><img src="@/assets/warp-windows/1.jpg" alt=""></p>

          <p class="font-bold">Bước 2: Bật WARP</p>
          <p>Sau khi cài đặt xong, mở WARP lên và thực hiện chấp nhận các điều khoản và thiết lập lần đầu.</p>
          <p><img src="@/assets/warp-windows/2.jpg" alt=""></p>
          <p>Sau đó nhấn vào nút công tắc để chuyển về trạng thái bật. Khi chương trình báo "Connected" thì tức là bạn đã kết nối WARP thành công.</p>
          <p><img src="@/assets/warp-windows/3.jpg" alt=""></p>

          <p class="font-bold">Bước 3: Thử truy cập Cứu Truyện qua tên miền chính thức.</p>
          <p>Vẫn không truy cập được? Thử tham gia vào group <a href="https://www.facebook.com/groups/cuutruyen2vn" target="_blank">Mặt tối của Cứu Truyện</a>,
            hoặc nhắn tin cho <a href="https://facebook.com/cuutruyentranh" target="_blank">fanpage Cứu Truyện</a> để tìm sự trợ giúp!</p>
        </div>
      </Collapse>
    </div>

    <div class="collapsible">
      <button class="collapsible-title" @click="isExpandDohChrome = !isExpandDohChrome">Cách 2: Thiết lập DNS over HTTPS cho Google Chrome</button>

      <Collapse :when="isExpandDohChrome">
        <div class="collapsible-content prose prose-invert prose-gray">
          <p>Kể từ bản 117, Chrome và các trình duyệt dựa trên Chromium (Cốc Cốc, Microsoft Edge, Brave,...) đã hỗ trợ
            <strong>DNS over HTTPS (DOH)</strong> cùng với <strong>Encrypted Client Hello (ECH)</strong>.
            DOH cùng với ECH giúp mã hóa tên miền của trang web mà bạn đang ghé thăm, giúp bảo vệ quyền riêng tư cũng như vô hiệu khả năng giám sát và kiểm duyệt của các chính phủ và nhà mạng.</p>
          <p>DOH và ECH chưa được bật mặc định trên Chrome, nhưng bạn có thể kích hoạt chỉ với vài bước đơn giản.</p>
          <p class="">
            Dễ sử dụng: <span class="text-green-500">rất đơn giản</span><br>
            Tốc độ: <span class="text-green-500">rất nhanh</span><br>
            Chi phí: <span class="text-green-500">miễn phí</span>
          </p>
          <p class="font-bold">Bước 1: Cài đặt Google Chrome (tùy chọn)</p>
          <p>Bỏ qua bước này nếu bạn đã có sẵn Chrome trong máy.</p>
          <p>Tải Google Chrome qua đường link dưới đây.</p>
          <div class="flex mb-4">
            <a href="https://www.google.com/chrome/" target="_blank"
               class="bg-green-700 hover:bg-green-800 p-2 rounded transition no-underline block">
              Tải Google Chrome
            </a>
          </div>
          <p>Sau đó làm theo hướng dẫn ở liên kết phía trên để cài đặt.</p>

          <p class="font-bold">Bước 2: Đảm bảo Chrome đang ở bản 117 trở lên</p>
          <p>Nhấn vào nút <DotsVertical class="inline p-0.5 w-5 h-5 rounded border border-gray-300" />, sau đó chọn Trợ giúp, rồi nhấn Giới thiệu về Google Chrome</p>
          <p><img src="@/assets/doh-chrome/1.png" alt=""></p>
          <p>Để ý xem Chrome của bạn đã là bản lớn hơn 117 hay chưa</p>
          <p><img src="@/assets/doh-chrome/2.png" alt=""></p>

          <p class="font-bold">Bước 3: Bật thiết lập DNS riêng</p>
          <p>Đầu tiên, nhấn vào nút <DotsVertical class="inline p-0.5 w-5 h-5 rounded border border-gray-300" />, sau đó chọn Cài đặt</p>
          <p><img src="@/assets/doh-chrome/3.png" alt=""></p>
          <p>Ở màn hình Cài đặt, chuyển sang tab Quyền riêng tư và bảo mật, sau đó chọn Bảo mật</p>
          <p><img src="@/assets/doh-chrome/4.png" alt=""></p>
          <p>Đảm bảo rằng mục <i>Sử dụng hệ thống tên miền (DNS) bảo mật</i> đã được kích hoạt. Sau đó sử dụng nhà cung cấp DNS là Cloudflare như trong hình dưới đây.</p>
          <p><img src="@/assets/doh-chrome/5.png" alt=""></p>

          <p class="font-bold">Bước 4: Thử truy cập Cứu Truyện qua tên miền chính thức.</p>
          <p>Vẫn không truy cập được? Thử tham gia vào group <a href="https://www.facebook.com/groups/cuutruyen2vn" target="_blank">Mặt tối của Cứu Truyện</a>,
            hoặc nhắn tin cho <a href="https://facebook.com/cuutruyentranh" target="_blank">fanpage Cứu Truyện</a> để tìm sự trợ giúp!</p>
        </div>
      </Collapse>
    </div>

    <div class="collapsible">
      <button class="collapsible-title" @click="isExpandDohFirefox = !isExpandDohFirefox">Cách 2: Thiết lập DNS over HTTPS cho Firefox</button>

      <Collapse :when="isExpandDohFirefox">
        <div class="collapsible-content prose prose-invert prose-gray">
          <p>Kể từ bản 118, Firefox đã hỗ trợ
            <strong>DNS over HTTPS (DOH)</strong> cùng với <strong>Encrypted Client Hello (ECH)</strong>.
            DOH cùng với ECH giúp mã hóa tên miền của trang web mà bạn đang ghé thăm, giúp bảo vệ quyền riêng tư
            cũng như vô hiệu khả năng giám sát và kiểm duyệt của các chính phủ và nhà mạng.</p>
          <p>DOH và ECH chưa được bật mặc định trên Firefox, nhưng bạn có thể kích hoạt chỉ với vài bước đơn giản.</p>
          <p class="">
            Dễ sử dụng: <span class="text-green-500">rất đơn giản</span><br>
            Tốc độ: <span class="text-green-500">rất nhanh</span><br>
            Chi phí: <span class="text-green-500">miễn phí</span>
          </p>
          <p class="font-bold">Bước 1: Cài đặt Firefox (tùy chọn)</p>
          <p>Bỏ qua bước này nếu bạn đã có sẵn Firefox trong máy.</p>
          <p>Tải Firefox qua đường link dưới đây.</p>
          <div class="flex mb-4">
            <a href="https://www.mozilla.org/vi/firefox/new/" target="_blank"
               class="bg-green-700 hover:bg-green-800 p-2 rounded transition no-underline block">
              Tải Firefox
            </a>
          </div>
          <p>Sau đó làm theo hướng dẫn ở liên kết phía trên để cài đặt.</p>

          <p class="font-bold">Bước 2: Đảm bảo Firefox đang ở bản 118 trở lên</p>
          <p>Nhấn vào nút <Menu class="inline p-0.5 w-5 h-5 rounded border border-gray-300" />, sau đó chọn Trợ giúp, rồi nhấn Về Firefox.
            Để ý xem Firefox của bạn đã là bản lớn hơn 118 hay chưa</p>
          <p><img src="@/assets/doh-firefox/1.png" alt=""></p>

          <p class="font-bold">Bước 3: Bật thiết lập DNS riêng</p>
          <p>Đầu tiên, nhấn vào nút <Menu class="inline p-0.5 w-5 h-5 rounded border border-gray-300" />, sau đó chọn Cài đặt</p>
          <p>Ở màn hình Cài đặt, chuyển sang tab Riêng tư và bảo mật, sau đó cuộn xuống dưới để tìm phần DNS qua HTTPS</p>
          <p><img src="@/assets/doh-firefox/2.png" alt=""></p>
          <p>Chọn Bảo vệ tối đa, và đảm bảo phần Chọn nhà cung cấp là Cloudflare</p>
          <p><img src="@/assets/doh-firefox/3.png" alt=""></p>

          <p class="font-bold">Bước 4: Thử truy cập Cứu Truyện qua tên miền chính thức.</p>
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
import { DotsVertical, Menu } from 'mdue'

const isExpandWarp = ref(false)
const isExpandDohChrome = ref(false)
const isExpandDohFirefox = ref(false)
</script>
