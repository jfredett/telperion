# 22-AUG-2024

## 1229

An `fio` run against pinky's disk prior to no-rebuild-disk optimizations

```bash
sudo fio --name=test --size=1G --rw=write --bs=1M --numjobs=4 --time_based --runtime=30 --filename=/dev/sda
test: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
...
fio-3.37
Starting 4 processes
Jobs: 4 (f=4): [W(4)][100.0%][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=2750: Thu Aug 22 12:10:46 2024
  write: IOPS=226, BW=226MiB/s (237MB/s)(7169MiB/31716msec); 0 zone resets
    clat (usec): min=116, max=12018, avg=763.63, stdev=1043.90
     lat (usec): min=130, max=12047, avg=806.68, stdev=1057.49
    clat percentiles (usec):
     |  1.00th=[  141],  5.00th=[  163], 10.00th=[  176], 20.00th=[  194],
     | 30.00th=[  219], 40.00th=[  281], 50.00th=[  359], 60.00th=[  519],
     | 70.00th=[  611], 80.00th=[ 1037], 90.00th=[ 1991], 95.00th=[ 2802],
     | 99.00th=[ 5211], 99.50th=[ 6587], 99.90th=[ 8455], 99.95th=[10683],
     | 99.99th=[11994]
   bw (  KiB/s): min=47104, max=1468416, per=79.19%, avg=733202.80, stdev=453080.41, samples=20
   iops        : min=   46, max= 1434, avg=715.85, stdev=442.41, samples=20
  lat (usec)   : 250=37.73%, 500=20.59%, 750=16.75%, 1000=4.42%
  lat (msec)   : 2=10.62%, 4=7.49%, 10=2.34%, 20=0.06%
  cpu          : usr=0.63%, sys=16.82%, ctx=28134, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7169,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1
test: (groupid=0, jobs=1): err= 0: pid=2751: Thu Aug 22 12:10:46 2024
  write: IOPS=226, BW=226MiB/s (237MB/s)(7169MiB/31716msec); 0 zone resets
    clat (usec): min=119, max=12508, avg=771.10, stdev=1055.80
     lat (usec): min=132, max=12522, avg=819.88, stdev=1076.50
    clat percentiles (usec):
     |  1.00th=[  137],  5.00th=[  161], 10.00th=[  172], 20.00th=[  188],
     | 30.00th=[  212], 40.00th=[  251], 50.00th=[  347], 60.00th=[  506],
     | 70.00th=[  627], 80.00th=[ 1106], 90.00th=[ 2024], 95.00th=[ 2835],
     | 99.00th=[ 5211], 99.50th=[ 6456], 99.90th=[ 8717], 99.95th=[11731],
     | 99.99th=[12518]
   bw (  KiB/s): min=49152, max=1460224, per=79.18%, avg=733130.80, stdev=458135.71, samples=20
   iops        : min=   48, max= 1426, avg=715.85, stdev=447.40, samples=20
  lat (usec)   : 250=39.88%, 500=19.74%, 750=14.28%, 1000=4.77%
  lat (msec)   : 2=11.09%, 4=8.02%, 10=2.13%, 20=0.08%
  cpu          : usr=0.64%, sys=8.89%, ctx=13486, majf=0, minf=9
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7169,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1
test: (groupid=0, jobs=1): err= 0: pid=2752: Thu Aug 22 12:10:46 2024
  write: IOPS=226, BW=226MiB/s (237MB/s)(7169MiB/31713msec); 0 zone resets
    clat (usec): min=116, max=14401, avg=767.40, stdev=986.74
     lat (usec): min=129, max=14445, avg=812.40, stdev=1010.80
    clat percentiles (usec):
     |  1.00th=[  141],  5.00th=[  165], 10.00th=[  176], 20.00th=[  196],
     | 30.00th=[  223], 40.00th=[  314], 50.00th=[  457], 60.00th=[  537],
     | 70.00th=[  644], 80.00th=[ 1037], 90.00th=[ 1958], 95.00th=[ 2638],
     | 99.00th=[ 4883], 99.50th=[ 5866], 99.90th=[ 8356], 99.95th=[ 9372],
     | 99.99th=[14353]
   bw (  KiB/s): min=49152, max=1464320, per=79.18%, avg=733117.15, stdev=468100.25, samples=20
   iops        : min=   48, max= 1430, avg=715.80, stdev=457.10, samples=20
  lat (usec)   : 250=34.87%, 500=17.59%, 750=21.84%, 1000=5.08%
  lat (msec)   : 2=11.06%, 4=7.45%, 10=2.08%, 20=0.03%
  cpu          : usr=0.58%, sys=17.00%, ctx=32351, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7169,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1
test: (groupid=0, jobs=1): err= 0: pid=2753: Thu Aug 22 12:10:46 2024
  write: IOPS=226, BW=226MiB/s (237MB/s)(7169MiB/31713msec); 0 zone resets
    clat (usec): min=118, max=13884, avg=725.33, stdev=934.99
     lat (usec): min=133, max=13899, avg=764.68, stdev=957.32
    clat percentiles (usec):
     |  1.00th=[  143],  5.00th=[  169], 10.00th=[  182], 20.00th=[  206],
     | 30.00th=[  235], 40.00th=[  326], 50.00th=[  441], 60.00th=[  529],
     | 70.00th=[  619], 80.00th=[  881], 90.00th=[ 1696], 95.00th=[ 2474],
     | 99.00th=[ 4424], 99.50th=[ 5735], 99.90th=[ 8586], 99.95th=[10028],
     | 99.99th=[13829]
   bw (  KiB/s): min=47104, max=1538048, per=79.19%, avg=733147.95, stdev=507977.04, samples=20
   iops        : min=   46, max= 1502, avg=715.85, stdev=496.10, samples=20
  lat (usec)   : 250=31.58%, 500=21.30%, 750=22.89%, 1000=6.29%
  lat (msec)   : 2=9.97%, 4=6.42%, 10=1.51%, 20=0.04%
  cpu          : usr=0.66%, sys=11.93%, ctx=22927, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7169,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=904MiB/s (948MB/s), 226MiB/s-226MiB/s (237MB/s-237MB/s), io=28.0GiB (30.1GB), run=31713-31716msec

Disk stats (read/write):
  sda: ios=48/37923, sectors=2088/14821512, merge=0/1814766, ticks=41/38231, in_queue=38273, util=80.36%
```

This shows the performance of the disk before the optimizations were applied. The average write
bandwidth was 226MiB/s per job.

After optimizations:

```bash
[nix-shell:~]$ sudo fio --name=test --size=1G --rw=write --bs=1M --numjobs=4 --time_based --runtime=30 --filename=/dev/sda
test: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
...
fio-3.37
Starting 4 processes
Jobs: 4 (f=4): [W(4)][100.0%][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=2287: Thu Aug 22 12:32:06 2024
  write: IOPS=242, BW=242MiB/s (254MB/s)(7274MiB/30002msec); 0 zone resets
    clat (usec): min=115, max=11338, avg=780.81, stdev=1128.41
     lat (usec): min=128, max=11357, avg=822.11, stdev=1144.67
    clat percentiles (usec):
     |  1.00th=[  139],  5.00th=[  153], 10.00th=[  163], 20.00th=[  186],
     | 30.00th=[  210], 40.00th=[  255], 50.00th=[  338], 60.00th=[  482],
     | 70.00th=[  611], 80.00th=[ 1045], 90.00th=[ 2057], 95.00th=[ 3032],
     | 99.00th=[ 5866], 99.50th=[ 7242], 99.90th=[ 8848], 99.95th=[ 9765],
     | 99.99th=[11338]
   bw (  KiB/s): min=217088, max=1378932, per=83.24%, avg=826512.11, stdev=399862.13, samples=18
   iops        : min=  212, max= 1346, avg=806.94, stdev=390.42, samples=18
  lat (usec)   : 250=39.37%, 500=22.46%, 750=13.46%, 1000=4.07%
  lat (msec)   : 2=10.15%, 4=7.66%, 10=2.80%, 20=0.03%
  cpu          : usr=0.58%, sys=9.77%, ctx=13666, majf=0, minf=11
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7274,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1
test: (groupid=0, jobs=1): err= 0: pid=2288: Thu Aug 22 12:32:06 2024
  write: IOPS=242, BW=242MiB/s (254MB/s)(7268MiB/30001msec); 0 zone resets
    clat (usec): min=114, max=12352, avg=779.11, stdev=1119.28
     lat (usec): min=127, max=12369, avg=824.92, stdev=1148.33
    clat percentiles (usec):
     |  1.00th=[  137],  5.00th=[  153], 10.00th=[  165], 20.00th=[  190],
     | 30.00th=[  215], 40.00th=[  262], 50.00th=[  330], 60.00th=[  498],
     | 70.00th=[  635], 80.00th=[ 1029], 90.00th=[ 2024], 95.00th=[ 2868],
     | 99.00th=[ 5604], 99.50th=[ 6980], 99.90th=[ 9503], 99.95th=[10552],
     | 99.99th=[12387]
   bw (  KiB/s): min=143360, max=1338135, per=86.83%, avg=862112.00, stdev=386039.48, samples=17
   iops        : min=  140, max= 1306, avg=841.71, stdev=376.96, samples=17
  lat (usec)   : 250=38.22%, 500=21.86%, 750=14.82%, 1000=4.76%
  lat (msec)   : 2=10.20%, 4=7.11%, 10=2.94%, 20=0.08%
  cpu          : usr=0.66%, sys=12.81%, ctx=19149, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7268,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1
test: (groupid=0, jobs=1): err= 0: pid=2289: Thu Aug 22 12:32:06 2024
  write: IOPS=242, BW=242MiB/s (254MB/s)(7274MiB/30001msec); 0 zone resets
    clat (usec): min=114, max=14804, avg=777.97, stdev=1124.70
     lat (usec): min=127, max=14824, avg=816.62, stdev=1139.54
    clat percentiles (usec):
     |  1.00th=[  139],  5.00th=[  157], 10.00th=[  169], 20.00th=[  196],
     | 30.00th=[  221], 40.00th=[  289], 50.00th=[  416], 60.00th=[  506],
     | 70.00th=[  611], 80.00th=[  988], 90.00th=[ 1991], 95.00th=[ 2769],
     | 99.00th=[ 5866], 99.50th=[ 7308], 99.90th=[ 9896], 99.95th=[11600],
     | 99.99th=[14746]
   bw (  KiB/s): min=147456, max=1334055, per=83.26%, avg=826649.56, stdev=404642.46, samples=18
   iops        : min=  144, max= 1302, avg=807.11, stdev=395.13, samples=18
  lat (usec)   : 250=35.17%, 500=23.87%, 750=16.85%, 1000=4.44%
  lat (msec)   : 2=9.76%, 4=7.44%, 10=2.39%, 20=0.08%
  cpu          : usr=0.58%, sys=17.30%, ctx=23868, majf=0, minf=11
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7274,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1
test: (groupid=0, jobs=1): err= 0: pid=2290: Thu Aug 22 12:32:06 2024
  write: IOPS=242, BW=242MiB/s (254MB/s)(7275MiB/30001msec); 0 zone resets
    clat (usec): min=115, max=13448, avg=766.45, stdev=1029.11
     lat (usec): min=128, max=13467, avg=808.44, stdev=1064.34
    clat percentiles (usec):
     |  1.00th=[  139],  5.00th=[  157], 10.00th=[  167], 20.00th=[  196],
     | 30.00th=[  235], 40.00th=[  334], 50.00th=[  453], 60.00th=[  529],
     | 70.00th=[  635], 80.00th=[ 1004], 90.00th=[ 1844], 95.00th=[ 2606],
     | 99.00th=[ 5145], 99.50th=[ 6718], 99.90th=[ 9241], 99.95th=[10814],
     | 99.99th=[13435]
   bw (  KiB/s): min=219136, max=1371465, per=83.25%, avg=826587.39, stdev=393746.64, samples=18
   iops        : min=  214, max= 1339, avg=807.06, stdev=384.45, samples=18
  lat (usec)   : 250=31.67%, 500=23.78%, 750=20.15%, 1000=4.30%
  lat (msec)   : 2=11.12%, 4=6.83%, 10=2.08%, 20=0.07%
  cpu          : usr=0.62%, sys=22.99%, ctx=38044, majf=0, minf=11
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,7275,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=970MiB/s (1017MB/s), 242MiB/s-242MiB/s (254MB/s-254MB/s), io=28.4GiB (30.5GB), run=30001-30002msec

Disk stats (read/write):
  sda: ios=75/38839, sectors=3216/14692656, merge=0/1797743, ticks=54/34008, in_queue=34062, util=77.86%
```

The average write bandwidth increased to 242MiB/s per job.

About 10% improvement.
